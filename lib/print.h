#ifndef MEGADEV__PRINT_H
#define MEGADEV__PRINT_H

#include "types.h"

void print_c(char* string, u16 nametable_offset);

extern void printval_u8_c(u8* value, u16 xy_pos);

extern void printval_u16_c(u16* value, u16 xy_pos);

extern void printval_u32_c(u32* value, u16 xy_pos);

#endif
