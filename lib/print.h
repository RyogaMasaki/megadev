#ifndef MEGADEV__PRINT_H
#define MEGADEV__PRINT_H

#include "types.h"



void print_c(char* string, u16 nametable_offset) {
  register char* string_a0 asm("a0") = string;
  register u16 nametable_offset_d1 asm("d0") = nametable_offset;

  asm("jsr print" ::"a"(string_a0), "d"(nametable_offset_d1) : "a5");
};

extern void printval_u8_c(u8* value, u16 xy_pos);

extern void printval_u16_c(u16* value, u16 xy_pos);

extern void printval_u32_c(u32* value, u16 xy_pos);

#endif
