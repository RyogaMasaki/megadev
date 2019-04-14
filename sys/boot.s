/* 
	MEGADEV
	https://github.com/RyogaMasaki/megadev
*/

/* Hardware constants & helper macros */
.include "global.s"

.org 0x00000000

.text
.global _start
_start:
/* M68k vector table */
.include "vectors.s"

/* Megadrive program header */
.include "header.s"

/* Exception handling */
.include "exceptions.s"

/* Interrupt handlers */
.include "interrupts.s"

/* Utility functions */
.include "utils.s"

/* Initial environment configuration */
.include "config.s"

/* Initial system resources (font, palette) */
.include "sysres.s"

.text
_sysinit:
	INTERRUPT_DISABLE
	move.b	VERSION, d0 	| Check for TMSS
	andi.b	#0x0f, d0
	beq	1f	| If version 0, skip TMSS
	move.l	#0x53454741, IO_TMSS	| Write 'SEGA' to TMSS port

	/* clear RAM */
1:clr.l d0
	clr.l d6
	movea.l d0, a6
	/* move a6, %sp */	/* reset stack pointer (A7) */ /*TODO: Why are we resetting the sp? */
	move.w #0x3FF, d7

2:move.l	d0, -(%a6)	/* decrease ptr till we hit 0xFFE00000 */
	dbra d7, 2b

	/* Z80 INIT */
	move.w  #0x100, Z80_BUSREQ
	move.w  #0x100, Z80_RESET
1:btst	#0,  Z80_BUSREQ
	bne.s	1b

	lea     z80_init_program, a0
	lea     Z80_ADDR, a1
	move.w  #(z80_init_program_len - 1), d7
1:move.b  (a0)+,(a1)+	 | data writes to Z80 are byte size
	dbf	d7, 1b

	move.w  #0, Z80_RESET
	move.w  #0, Z80_BUSREQ
	move.w  #0x100, Z80_RESET

	/* VDP INIT */
	/* clear VRAM */
	/* TODO: dma vram fill? */
	move.l #VRAM_WRITE, VDP_CTRL
	move.l #0x3fff, d7
1:move.l d0, (VDP_DATA)
	dbra %d7, 1b
	
	/* set up initial register values */
	lea VDP_CTRL, a5

	move.w #0x8000, d5		| start at first register
	move.w #0x0100, d7		| each register addr is offset by 0x100

	moveq #0x12, d0				| 0x17 registers
	lea vdp_init_regs, a0

1:move.b (a0)+, d5
	move.w d5, (a5)
	add.w d7, d5
	dbra d0, 1b

	/* set plane width mirror in memory for print functions */
	move.b #0, plane_width

	/* load system font */
	move.l #VRAM_WRITE, VDP_CTRL
	lea sysfont, a0
	move.l #sysfontlen, d0

1:move.l (a0)+, VDP_DATA
	dbra d0, 1b

	/* load system palette */
	moveq #0, d0
	lea syspal, a0
	jsr vdp_load_subpal
	
	moveq #1, d0
	lea syspal, a0
	jsr vdp_load_subpal

	jsr setup_inputs

	/* and on with the show... */
	jmp _main

.section .rodata
z80_init_program:
	dc.l    0xAF01D91F, 0x11270021, 0x2600F977 
	dc.l    0xEDB0DDE1, 0xFDE1ED47, 0xED4FD1E1
	dc.l    0xF108D9C1, 0xD1E1F1F9, 0xF3ED5636
	dc.w    0xE9E9
.equ z80_init_program_len, .-z80_init_program
