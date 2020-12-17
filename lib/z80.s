
/* Z80 Control */
.equ    Z80_RAM,   0xA00000
.equ		Z80_BUSREQ, 0xA11100
.equ		Z80_RESET,	0xA11200

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
	movea #0, a1
	move.l z80_init_program_len, d1

/*
	load_z80_data
	Interrupts should be disabled before calling this subroutine

	IN:
		a0 - ptr to data
		a1 - Z80 RAM offset
		d0 - data size
*/
load_z80_data:
	move.w  #0x100, Z80_BUSREQ
	move.w  #0x100, Z80_RESET
1:btst	#0,  Z80_BUSREQ
	bne.s	1b

	adda.l Z80_RAM, a1
	subq #1, d0
1:move.b  (a0)+, (a1)+
	dbf	d0, 1b

	move.w  #0, Z80_RESET
	nop
	nop
	nop
	nop
	move.w  #0x100, Z80_RESET
	rts
