/* 
	MEGADEV
	https://github.com/RyogaMasaki/megadev
*/

/* Hardware definitions */
.include "hwdef.s"

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

_sysinit:
	move	#0x2700, sr		| Disable interrupts
	move.b	(VERSION), d0 	| Check for TMSS
	andi.b	#0x0f, d0
	beq	1f	| If version 0, skip TMSS
	move.l	#0x53454741, IO_TMSS	| Write 'SEGA' to TMSS port

	/* clear RAM */
1:clr.l d0
	clr.l d6
	movea.l d0, a6
	/*move a6, %sp*/	/* reset stack pointer (A7) */ /*TODO: Why are we resetting the sp? */
	move.w #0x3FF, d7

	2:move.l	d0, -(%a6)	/* decrease ptr till we hit 0xFFE00000 */
		dbra d7, 2b		

	/* VDP INIT */
	/* clear VRAM */
	/* TODO: dma vram fill? */
	move.w #VRAM_WRITE, VDP_CTRL
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

	/* load system font */
	move.w #VRAM_WRITE, VDP_CTRL
	lea sysfont, a0
	move.l #sysfontlen, d0

	1:
	move.l (a0)+, (VDP_DATA)
	dbra d0, 1b

	/* load system palette */
	moveq #0, d0
	lea syspal, a0
	jsr vdp_load_subpal

	jsr setup_input

	/* and on with the show... */
	jmp _main

