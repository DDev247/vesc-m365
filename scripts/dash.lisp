; M365 dashboard compability lisp script v1.0 by Netzpfuscher and 1zuna
; UART Wiring: red=5V black=GND yellow=COM-TX (UART-HDX) green=COM-RX (button)+3.3V with 1K Resistor
; Guide (German): https://rollerplausch.com/threads/vesc-controller-einbau-1s-pro2-g30.6032/

; TODO: Implement FWK by speed, above 36km/h increase current by 1A
; edited by ddev

; -> User parameters (change these to your needs)
(def software-adc 0)
(def min-adc-throttle 0.1)
(def min-adc-brake 0.1)

; Current Display settings
(def show-current-scale 1) ; shows the current percentage on the battery bar when riding
(def show-current-scale-phase 0) ; 1 - shows phase amps, 0 - shows battery amps
; Current Display limits
(def phase-current-max 65) ; maximum positive (accelerating) phase current
(def phase-current-min -25) ; maximum negative (braking) phase current
(def battery-current-max 30) ; maximum positive (accelerating) battery current
(def battery-current-min -10) ; maximum negative (braking) battery current

; Other settings
(def show-batt-in-idle 1) ; show battery in idle in secret mode?
(def min-start-speed -0.1) ; start at 0 because its easier to test that way (-0.1 because get-speed returns -0.0 at 0 speed)
(def lock-start-speed (/ 1.0 3.6)) ; lock mode beep/brake speed
(def button-safety-speed (/ 0.1 3.6)) ; disabling button above 0.1 km/h (due to safety reasons)

; Speed modes (km/h, current multiplier, watts, field weakening current max)
(def eco-speed (/ 7 3.6))
(def eco-current 0.3)
(def eco-watts 400)
(def eco-fw 0)
(def drive-speed (/ 17 3.6))
(def drive-current 0.6)
(def drive-watts 500)
(def drive-fw 0)
(def sport-speed (/ 21 3.6))
(def sport-current 1.0)
(def sport-watts 700)
(def sport-fw 0)

; Secret speed modes. To enable, press the button 2 times while holding break and throttle at the same time.
(def secret-enabled 1)
(def secret-eco-speed (/ 50 3.6))
(def secret-eco-current 1.0)
(def secret-eco-watts 20000)
(def secret-eco-fw 5)
(def secret-drive-speed (/ 1000 3.6))
(def secret-drive-current 1.0)
(def secret-drive-watts 1500000)
(def secret-drive-fw 20) ; the same as sport but sport has adaptive fwk
(def secret-sport-speed (/ 70 3.6)) ; 1000 km/h easy
(def secret-sport-current 1.0)
(def secret-sport-watts 1500000)
(def secret-sport-fw 30) ; adaptive, doesn't really matter above 35 kmh

; -> Code starts here (DO NOT CHANGE ANYTHING BELOW THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING)

; Load VESC CAN code serer
(import "pkg@://vesc_packages/lib_code_server/code_server.vescpkg" 'code-server)
(read-eval-program code-server)

; Packet handling
(uart-start 115200 'half-duplex)
(gpio-configure 'pin-rx 'pin-mode-in-pu)
(def tx-frame (array-create 14))
(bufset-u16 tx-frame 0 0x55AA)
(bufset-u16 tx-frame 2 0x0821)
(bufset-u16 tx-frame 4 0x6400)
(def uart-buf (array-create 64))

; Button handling

(def presstime (systime))
(def presses 0)

; Mode states

(def off 0)       ; scooter off?
(def lock 0)      ; scooter locked?
(def speedmode 4) ; speed mode enum 1-eco 2-drive 3-sport
(def light 0)     ; light turned on?
(def unlock 0)    ; secret currently enabled?

; Sound feedback

(def feedback 0)

(if (= software-adc 1)
    (app-adc-detach 3 1)
    (app-adc-detach 3 0)
)

(defun adc-input(buffer) ; Frame 0x65
    {
        (let ((current-speed (* (get-speed) 3.6))
            (throttle (/(bufget-u8 uart-buf 4) 77.2)) ; 255/3.3 = 77.2
            (brake (/(bufget-u8 uart-buf 5) 77.2)))
            {
                (if (< throttle 0)
                    (setf throttle 0))
                (if (> throttle 3.3)
                    (setf throttle 3.3))
                (if (< brake 0)
                    (setf brake 0))
                (if (> brake 3.3)
                    (setf brake 3.3))

                ; Pass through throttle and brake to VESC
                (app-adc-override 0 throttle)
                (app-adc-override 1 brake)
            }
        )
    }
)

(defun handle-features()
    {
        (if (or (or (= off 1) (= lock 1) (< (* (get-speed) 3.6) min-start-speed)))
            (if (not (app-is-output-disabled)) ; Disable output when scooter is turned off
                {
                    (app-disable-output -1)
                    (set-current-rel 0)
                    ;(loopforeach i (can-list-devs)
                    ;    (canset-current i 0)
                    ;)
                }

            )
            (if (app-is-output-disabled) ; Enable output when scooter is turned on
                (app-disable-output 0)
            )
        )

        (if (= lock 1)
            {
                (set-current-rel 0) ; No current input when locked
                (if (or (> (* (get-speed) 3.6) lock-start-speed) (< (* (get-speed) 3.6) (- lock-start-speed)))
                    (set-brake-rel 1) ; Full power brake
                    (set-brake-rel 0) ; No brake
                )
            }
        )

        ; secret sport mode fwk to the metal above 25kmh - 30kmh
        ; disabled
        (if (= unlock 2)
            {
                (var speed (* (l-speed) 3.6))
                (if (and (> speed 25) (= speedmode 4)) ; speed higher than -32kmh- 25 and in sportmode (might save some clock cycles)
                    {
                        (var current (get-current-in))
                        (var difference (- battery-current-max current)) ; so if we are drawing 26 amps that will be 30 - 26 = 4 amps
                        (var multiplier (if (< speed 25)
                                0
                            (if (> speed 30)
                                1
                            (/ (- speed 25) 4)))) ; smoothing multiplier so its not a on/off switch or kick (could trigger OCP (?))
                        (set-param 'foc-fw-current-max (+ 5 (* (- difference 1) multiplier))) ; keep 1 amps of room
                        ;(print (str-merge (str-from-n (conf-get 'foc-fw-current-max)) " " (str-from-n difference) " " (str-from-n multiplier) " " (str-from-n (* (- difference 1) multiplier))))
                    }
                    (apply-mode) ; if speed is below -32kmh- 25kmh let it apply it manually (might be slow)
                )
            }
        )
    }
)

(defun update-dash(buffer) ; Frame 0x64
    {
        (var current-speed (* (l-speed) 3.6))
        (var battery (*(get-batt) 100))
        (var current 0)
        (if (= show-current-scale-phase 1)
            (if (< (get-current) 0)
                (set 'current (* (/ (get-current) phase-current-min) 100))
                (set 'current (* (/ (get-current) phase-current-max) 100))
            )
            (if (< (get-current-in) 0)
                (set 'current (* (/ (get-current-in) battery-current-min) 100))
                (set 'current (* (/ (get-current-in) battery-current-max) 100))
            )
        )

        ; mode field (1=drive, 2=eco, 4=sport, 8=charge, 16=off, 32=lock)
        (if (= off 1)
            (bufset-u8 tx-frame 6 16)
            (if (= lock 1)
                (bufset-u8 tx-frame 6 32) ; lock display
                (if (or (> (get-temp-fet) 60) (> (get-temp-mot) 60)) ; temp icon will show up above 60 degree
                    (bufset-u8 tx-frame 6 (+ 128 speedmode))
                    (bufset-u8 tx-frame 6 speedmode)
                )
            )
        )

        ; batt field
        (if (= show-current-scale 1)
            (if (> current-speed 1)
                (bufset-u8 tx-frame 7 current)
                (bufset-u8 tx-frame 7 battery)
            )
            (bufset-u8 tx-frame 7 battery)
        )

        ; light field
        (if (= off 0)
            (bufset-u8 tx-frame 8 light)
            (bufset-u8 tx-frame 8 0)
        )

        ; beep field
        (if (= lock 1)
            (if (or (> current-speed lock-start-speed) (< current-speed (- lock-start-speed)))
                (bufset-u8 tx-frame 9 1) ; beep lock
                (bufset-u8 tx-frame 9 0))
            (if (> feedback 0)
                {
                    (bufset-u8 tx-frame 9 1)
                    (set 'feedback (- feedback 1))
                }
                (bufset-u8 tx-frame 9 0)
            )
        )

        ; speed field
        (if (= (+ show-batt-in-idle unlock) 2)
            (if (> current-speed 1)
                (bufset-u8 tx-frame 10 current-speed)
                (bufset-u8 tx-frame 10 battery))
            (bufset-u8 tx-frame 10 current-speed)
        )

        ; error field
        (bufset-u8 tx-frame 11 (get-fault))

        ; calc crc
        (var crc 0)
        (looprange i 2 12
            (set 'crc (+ crc (bufget-u8 tx-frame i))))
        (var c-out (bitwise-xor crc 0xFFFF))
        (bufset-u8 tx-frame 12 c-out)
        (bufset-u8 tx-frame 13 (shr c-out 8))

        ; write
        (uart-write tx-frame)
    }
)

(defun read-frames()
    (loopwhile t
        {
            (uart-read-bytes uart-buf 3 0)
            (if (= (bufget-u16 uart-buf 0) 0x55aa)
                {
                    (var len (bufget-u8 uart-buf 2))
                    (var crc len)
                    (if (and (> len 0) (< len 60)) ; max 64 bytes
                        {
                            (uart-read-bytes uart-buf (+ len 4) 0)
                            (looprange i 0 len
                                (set 'crc (+ crc (bufget-u8 uart-buf i))))
                            (if (=(+(shl(bufget-u8 uart-buf (+ len 2))8) (bufget-u8 uart-buf (+ len 1))) (bitwise-xor crc 0xFFFF))
                                (handle-frame (bufget-u8 uart-buf 1))
                            )
                        }
                    )
                }
            )
        }
    )
)

(defun handle-frame(code)
    {
        (if (and (= code 0x65) (= software-adc 1))
            (adc-input uart-buf)
        )

        (update-dash uart-buf)
    }
)

(defun handle-button()
    (if (= presses 1) ; single press
        (if (= off 1) ; is it off? turn on scooter again
            {
                (set 'off 0) ; turn on
                (set 'feedback 1) ; beep feedback
                (set 'unlock 0) ; Disable unlock on turn off
                (apply-mode) ; Apply mode on start-up
                (stats-reset) ; reset stats when turning on
            }
            (set 'light (bitwise-xor light 1)) ; toggle light
        )
        (if (>= presses 2) ; double press
            {
                (if (> (get-adc-decoded 1) min-adc-brake) ; if brake is pressed
                    (if (and (= secret-enabled 1) (> (get-adc-decoded 0) min-adc-throttle))
                        {
                            (set 'unlock (bitwise-xor unlock 1))
                            (set 'feedback 2) ; beep 2x
                            (apply-mode)
                        }
                        {
                            (set 'unlock 0)
                            (apply-mode)
                            (set 'lock (bitwise-xor lock 1)) ; lock on or off
                            (set 'feedback 1) ; beep feedback
                        }
                    )
                    {
                        (if (= lock 0)
                            {
                                (cond
                                    ((= speedmode 1) (set 'speedmode 4))
                                    ((= speedmode 2) (set 'speedmode 1))
                                    ((= speedmode 4) (set 'speedmode 2))
                                )
                                (apply-mode)
                            }
                        )
                    }
                )
            }
        )
    )
)

(defun handle-holding-button()
    {
        (if (= (+ lock off) 0) ; it is locked and off?
            {
                (set 'unlock 0) ; Disable unlock on turn off
                (apply-mode)
                (set 'off 1) ; turn off
                (set 'light 0) ; turn off light
                (set 'feedback 1) ; beep feedback
            }
        )
    }
)

(defun reset-button()
    {
        (set 'presstime (systime)) ; reset press time again
        (set 'presses 0)
    }
)

; Speed mode implementation

(defun apply-mode()
    (if (= unlock 0)
        (if (= speedmode 1)
            (configure-speed drive-speed drive-watts drive-current drive-fw)
            (if (= speedmode 2)
                (configure-speed eco-speed eco-watts eco-current eco-fw)
                (if (= speedmode 4)
                    (configure-speed sport-speed sport-watts sport-current sport-fw)
                )
            )
        )
        (if (= speedmode 1)
            (configure-speed secret-drive-speed secret-drive-watts secret-drive-current secret-drive-fw)
            (if (= speedmode 2)
                (configure-speed secret-eco-speed secret-eco-watts secret-eco-current secret-eco-fw)
                (if (= speedmode 4)
                    (configure-speed secret-sport-speed secret-sport-watts secret-sport-current secret-sport-fw)
                )
            )
        )
    )
)

(defun configure-speed(speed watts current fw)
    {
        (set-param 'max-speed speed)
        (set-param 'l-watt-max watts)
        (set-param 'l-current-max-scale current)
        (set-param 'foc-fw-current-max fw)
    }
)

(defun set-param (param value)
    {
        (conf-set param value)
        (loopforeach id (can-list-devs)
            (looprange i 0 5 {
                (if (eq (rcode-run id 0.1 `(conf-set (quote ,param) ,value)) t) (break t))
                false
            })
        )
    }
)

(defun l-speed()
    {
        (var l-speed (get-speed))
        (loopforeach i (can-list-devs)
            {
                (var l-can-speed (canget-speed i))
                (if (< l-can-speed l-speed)
                    (set 'l-speed l-can-speed)
                )
            }
        )

        l-speed
    }
)

(defun button-logic()
    {
        ; Assume button is not pressed by default
        (var buttonold 0)
        (loopwhile t
            {
                (var button (gpio-read 'pin-rx))
                (sleep 0.05) ; wait 50 ms to debounce
                (var buttonconfirm (gpio-read 'pin-rx))
                (if (not (= button buttonconfirm))
                    (set 'button 0)
                )

                (if (> buttonold button)
                    {
                        (set 'presses (+ presses 1))
                        (set 'presstime (systime))
                    }
                    (button-apply button)
                )

                (set 'buttonold button)
                (handle-features)
            }
        )
    }
)

(defun button-apply(button)
    {
        (var time-passed (- (systime) presstime))
        (var is-active (or (= off 1) (<= (get-speed) button-safety-speed)))

        (if (> time-passed 2500) ; after 2500 ms
            (if (= button 0) ; check button is still pressed
                (if (> time-passed 6000) ; long press after 6000 ms
                    {
                        (if is-active
                            (handle-holding-button)
                        )
                        (reset-button) ; reset button
                    }
                )
                (if (> presses 0) ; if presses > 0
                    {
                        (if is-active
                            (handle-button) ; handle button presses
                        )
                        (reset-button) ; reset button
                    }
                )
            )
        )
    }
)

(defun send-params()
    (loopwhile t
        {
            (send-data (list off lock speedmode light unlock))
            (sleep 1)
        }
    )
)

; Apply mode on start-up
(apply-mode)

; Spawn UART reading frames thread
(spawn 150 read-frames)
(spawn 50 send-params)
(button-logic) ; Start button logic in main thread - this will block the main thread