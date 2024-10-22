#include <Arduino.h>

// #include "Hexdump.h"
#include "bms.h"

#define halt while(1) {};

void setup() {
    Serial.begin(115200);
    Serial.printf("vesc-m365 esp32 boot\n");

    // rear light
    pinMode(4, OUTPUT);

    // init BMS comm
    bms_init();

    // TODO: init CANbus

    Serial.printf("ready\n");
}

void loop() {
    // loop code
    analogWrite(4, 0);
    bms_loop();

    // Serial.printf("TX2W:%i,RX2Y:%i\r\n", digitalRead(TX2), digitalRead(RX2));
    
    /*while(Serial2.available() > 0) {
        uint8_t buf[32];
        size_t read = Serial2.readBytes(buf, 32);
        hexdump(Serial, buf, read, true, "RX: ");
    }*/

    /*
    while(serialTx.available() > 0) {
        uint8_t buf[32];
        size_t read = serialRx.readBytes(buf, 32);
        hexdump(Serial, buf, read, true, "TX: ");
    }*/

}
