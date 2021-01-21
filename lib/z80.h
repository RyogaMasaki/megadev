#ifndef MEGADEV__Z80_H
#define MEGADEV__Z80_H

#include "types.h"

extern void load_z80_init_program();

extern void get_z80_bus();

extern void release_z80_bus();

extern void load_z80(u8 data[], u16 length);

#endif