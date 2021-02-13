
#include "macros.s"
#include "z80_def.h"

.section .rodata
.section .text

.global get_z80_bus
get_z80_bus:
  move.w #0x100, (Z80_BUSREQ)
1:btst #0, (Z80_BUSREQ)
  bne.s 1b
	rts

.global release_z80_bus
release_z80_bus:
  move.w #0, (Z80_BUSREQ)
	rts

/*
	load_z80_data

	IN:
		a0 - ptr to data
		d0 - data size
	BREAK: a1
*/
FUNC load_z80_data
	move sr, -(sp)
  ori #0x700, sr

  Z80_DO_RESET
	Z80_BUSREQUEST

	lea Z80_RAM, a1

	subq #1, d0
2:move.b  (a0)+, (a1)+
	dbf	d0, 2b

  Z80_DO_RESET
	Z80_BUSRELEASE
	

	move (sp)+, sr

	rts
