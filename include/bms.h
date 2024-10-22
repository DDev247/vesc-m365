
#ifndef BMS_H
#define BMS_H

#include <stdint.h>
#include <HardwareSerial.h>

extern HardwareSerial BMS_SERIAL;

// https://github.com/BotoX/xiaomi-m365-compatible-bms/blob/master/src/main.h

#define M365BMS_RADDR 0x22
#define M365BMS_WADDR 0x25

struct M365BMS
{ // little endian
/*00-1F*/   uint16_t unk1[16] = {0x5A, 0x5A, 0x00};
/*20-2D*/   char serial[14] = "";
/*2E-2F*/   uint16_t version = 0x900; // 0x115 = 1.1.5
/*30-31*/   uint16_t design_capacity = 0; // mAh
/*32-33*/   uint16_t real_capacity = 0; // mAh
/*34-35*/   uint16_t nominal_voltage = 0; // mV
/*36-37*/   uint16_t num_cycles = 0;
/*38-39*/   uint16_t num_charged = 0;
/*3A-3B*/   uint16_t max_voltage = 0; // V/100
/*3C-3D*/   uint16_t max_discharge_current = 0; // A/100
/*3E-3F*/   uint16_t max_charge_current = 0; // A/100
/*40-41*/   uint16_t date = 0; // MSB (7 bits year, 4 bits month, 5 bits day) LSB
/*42-47*/   uint8_t errors[6] = {0};
/*48-5F*/   uint16_t unk3[12] = {0};
/*60-61*/   uint16_t status = 1; // b0 = config valid, b6 = charging, b9 = overvoltage, b10 = overheat
/*62-63*/   uint16_t capacity_left = 0; // mAh
/*64-65*/   uint16_t percent_left = 0;
/*66-67*/   int16_t current = 0; // A/100
/*68-69*/   uint16_t voltage = 0; // V/100
/*6A-6B*/   uint8_t temperature[2] = {0, 0}; // °C - 20
/*6C-6D*/   uint16_t balance_bits = 0;
/*6E-75*/   uint16_t unk5[4] = {0};
/*76-77*/   uint16_t health = 100; // %, <60% = battery bad
/*78-7F*/   uint16_t unk6[4] = {0};
/*80-9D*/   uint16_t cell_voltages[15] = {0}; // mV
/*9E-A1*/   uint16_t unk7[2] = {0};
#if 0
/*A2-A3*/   uint16_t unk8 = 1; // 1 ?
/*A4-DF*/   uint16_t unk9[30] = {0};
/*E0-E0*/   uint8_t unk10 = 0x3F; // BMS specific value ?
/*E1-E1*/   uint8_t unk11 = 0; // 0 ?
/*E2-E2*/   uint8_t unk12 = 0x3C; // BMS specific value ?
/*E3-E4*/   uint16_t unk13 = 1; // 1 ?
/*E5-EB*/   char unk_serial[7] = "G55179"; // BMS specific value ?
/*EC-FF*/   uint8_t unk14[19];
#endif
} __attribute__((packed));

struct NinebotMessage
{
    bool valid = false;
    uint8_t header[2]; // 0x55, 0xAA

    uint8_t length; // length of data + 2
    uint8_t addr; // receiver address
    uint8_t mode; // read = 1 / write = 3
    uint8_t offset; // data offset/index in array
    uint8_t data[253]; // write = data, read = uint8_t read length

    uint16_t checksum; // (bytes without header) XOR 0xFFFF
};

void bms_init();
void bms_loop();
NinebotMessage bms_recv();
void bms_send(NinebotMessage &msg);

#endif
