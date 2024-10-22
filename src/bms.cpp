#include <Arduino.h>
#include "Hexdump.h"
#include "bms.h"

HardwareSerial BMS_SERIAL(1);

void bms_init() {

    BMS_SERIAL.setMode(UART_MODE_UART);
    BMS_SERIAL.begin(115200, SERIAL_8N1, 18, 19);

}

// bms activator:
// {0x55, 0xAA, 0x03, 0x22, 0x01, 0x30, 0x0C, 0x9D, 0xFF}
// 55 AA 03 22 01 30 0C 9D FF 00
// 55  AA 03     22      01   30     0C   9D FF       00
// header length address mode offset data checksum    termination for serial
//        03     22      01   30     0C               00
//        03     22      01   68     02               00
uint8_t activator[] = {0x55, 0xAA, 0x03, 0x22, 0x01, 0x30, 0x0C, 0x9D, 0xFF};

void bms_loop() {

    while(BMS_SERIAL.available()) BMS_SERIAL.read();
    BMS_SERIAL.flush();
    BMS_SERIAL.write(activator, 9);
    /*NinebotMessage msg = {};
    msg.length = 0x03;
    msg.addr = 0x22;
    msg.mode = 0x01;
    msg.offset = 0x68;
    msg.data[0] = 0x02;
    bms_send(msg);*/

    if(Serial.available()) {
        uint8_t buf[256];
        size_t len = Serial.readBytesUntil(0x00, buf, 255);

        NinebotMessage msg = {};
        msg.length = buf[0];
        msg.addr = buf[1];
        msg.mode = buf[2];
        msg.offset = buf[3];
        memcpy(msg.data, &buf[4], len - 4);
        bms_send(msg);
        //BMS_SERIAL.write(buf, len);

        Serial.printf("ok(%i)\n", len);
        Serial.printf("sent len: %02X/%i, addr: %02X/%i, mode: %s, offset: %02X/%i\n", msg.length,msg.length, msg.addr,msg.addr, (msg.mode == 1 ? "READ" : "WRITE"), msg.offset,msg.offset);
        hexdump(Serial, msg.data, msg.length - 2, true, "sent DATA: ");
    }
    delay(100);

    Serial.printf("Sent data, serial buffer: %i\n", BMS_SERIAL.available());
    if(BMS_SERIAL.available() > 0) {
        uint8_t buf[256];
        size_t len = BMS_SERIAL.readBytes(buf, 255);
        hexdump(Serial, buf, len, true, "recvd DATA: ");
    }

    // NinebotMessage msg = bms_recv();
    // if(msg.valid) {
        // Serial.printf("recv len: %02X/%i, addr: %02X/%i, mode: %s, offset: %02X/%i\n", msg.length,msg.length, msg.addr,msg.addr, (msg.mode == 1 ? "READ" : "WRITE"), msg.offset,msg.offset);
        // hexdump(Serial, msg.data, msg.length - 2, true, "recv DATA: ");
    //}

    delay(200);
}

NinebotMessage bms_recv() {
    NinebotMessage msg;
    static uint8_t recvd = 0;
    static unsigned long begin = 0;
    static uint16_t checksum;

    while(BMS_SERIAL.available()) {
        if(millis() >= begin + 100) { // 100ms timeout
            recvd = 0;
        }

        uint8_t byte = BMS_SERIAL.read();
        recvd++;

        switch(recvd) {
            case 1:
            {
                if(byte != 0x55)
                { // header1 mismatch
                    recvd = 0;
                    break;
                }

                msg.header[0] = byte;
                begin = millis();
            } break;

            case 2:
            {
                if(byte != 0xAA)
                { // header2 mismatch
                    recvd = 0;
                    break;
                }

                msg.header[1] = byte;
            } break;

            case 3: // length
            {
                if(byte < 2)
                { // too small
                    recvd = 0;
                    break;
                }

                msg.length = byte;
                checksum = byte;
            } break;

            case 4: // addr
            {
                // if(byte != M365BMS_WADDR)
                // { // we're not the receiver of this message
                    // recvd = 0;
                    // break;
                // }

                msg.addr = byte;
                checksum += byte;
            } break;

            case 5: // mode
            {
                msg.mode = byte;
                checksum += byte;
            } break;

            case 6: // offset
            {
                msg.offset = byte;
                checksum += byte;
            } break;

            default:
            {
                if(recvd - 7 < msg.length - 2)
                { // data
                    msg.data[recvd - 7] = byte;
                    checksum += byte;
                }
                else if(recvd - 7 - msg.length + 2 == 0)
                { // checksum LSB
                    msg.checksum = byte;
                }
                else
                { // checksum MSB and transmission finished
                    msg.checksum |= (uint16_t)byte << 8;
                    checksum ^= 0xFFFF;

                    if(checksum != msg.checksum)
                    { // invalid checksum
                        recvd = 0;
                        break;
                    }

                    msg.valid = true;
                    return msg;
                    recvd = 0;
                }
            } break;
        }
    }

    return msg;
}

void bms_send(NinebotMessage &msg) {
    msg.checksum = (uint16_t)msg.length + msg.addr + msg.mode + msg.offset;

    BMS_SERIAL.write(msg.header[0]);
    BMS_SERIAL.write(msg.header[1]);
    BMS_SERIAL.write(msg.length);
    BMS_SERIAL.write(msg.addr);
    BMS_SERIAL.write(msg.mode);
    BMS_SERIAL.write(msg.offset);
    for(uint8_t i = 0; i < msg.length - 2; i++)
    {
        BMS_SERIAL.write(msg.data[i]);
        msg.checksum += msg.data[i];
    }

    msg.checksum ^= 0xFFFF;
    BMS_SERIAL.write(msg.checksum & 0xFF);
    BMS_SERIAL.write((msg.checksum >> 8) & 0xFF);
    BMS_SERIAL.flush();
}
