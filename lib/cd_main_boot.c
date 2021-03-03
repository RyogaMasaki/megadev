/**
 * \file cd_main_boot.c
 * Boot ROM (Main CPU) system calls
 */

#include "types.h"
#include "cd_main_boot.h"

bool vdp_pal_fadeout(u8 index, u8 length) {
	// code expects 16 bit values, even though it all fits in
	// a byte...
	register u16 d0_index asm("d0") = (u16)index;
	register u16 d1_length asm("d1") = (u16)length;
	bool is_complete;
	asm(R"(
  jsr %p1
	beq 1f
	move.b #0, %0
	rts
1:move.b #1, %0
  rts
	)" : "=d"(is_complete) : "i"(_PAL_FADEOUT), "d"(d0_index), "d"(d1_length));

	return is_complete;
};
