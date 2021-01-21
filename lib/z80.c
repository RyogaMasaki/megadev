#include "z80.h"

void load_z80(u8 data[], u16 length) {
	register u32 a0_data asm("a0") = (u32)data;
	register u16 d0_length asm("d0") = length;

	asm("jsr load_z80_data" :: "d"(d0_length), "a"(a0_data) : "a1");
};
