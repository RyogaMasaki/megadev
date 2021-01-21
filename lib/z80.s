
#include "macros.s"
#include "z80_def.h"

.section .rodata

# TODO - externalize this into a sysres
z80_init_program:
	.long    0xAF01D91F, 0x11270021, 0x2600F977 
	.long    0xEDB0DDE1, 0xFDE1ED47, 0xED4FD1E1
	.long    0xF108D9C1, 0xD1E1F1F9, 0xF3ED5636
	.word    0xE9E9
.equ z80_init_program_len, .-z80_init_program

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

.global load_z80_init_program
load_z80_init_program:
	lea z80_init_program, a0
	move.l z80_init_program_len, d0

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
