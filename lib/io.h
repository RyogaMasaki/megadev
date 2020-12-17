#ifndef MEGADEV__IO_H
#define MEGADEV__IO_H

#include "types.h"

#define IN_UP 0b00000001
#define IN_DOWN 0b00000010
#define IN_LEFT 0b00000100
#define IN_RIGHT 0b00001000
#define IN_START 0b10000000
#define IN_A 0b01000000
#define IN_B 0b00010000
#define IN_C 0b00100000
/*
#define VDP_CTRL_32 (*(volatile u32*)0xC00004)
#define VDP_DATA_32 (*(volatile u32*)0xC00000)

#define VDP_CTRL_16 (*(volatile u16*)0xC00004)
#define VDP_DATA_16 (*(volatile u16*)0xC00000)
*/

extern u16 input_p1;
extern u16 input_p2;

extern u8 input_p1_hold;
extern u8 input_p1_press;

void update_inputs_c();

void put_ext(u8 value);

void init_ext_c();

u8 get_ext();

#endif
