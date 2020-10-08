/* 
	MEGADEV
	https://github.com/RyogaMasaki/megadev
*/

.org 0

/*
	As a general rule, the .rodata section should be kept	above
	the .text section due to some quirks in GAS. Please see README
	for more info.
*/
.section .rodata
/* Initial environment configuration */
.include "config.s"

/************ TEXT ************/
.align 2
.text
.global _start
_start:
/* M68k vector table */
.include "vectors.s"

/* Megadrive program header */
.include "md_header.s"

/* Exception handling */
.include "exceptions.s"

/* Interrupt handlers */
.include "interrupts.s"

.section .text
.global _sysinit
_sysinit:
	INTERRUPT_DISABLE
	move.b	VERSION, d0 	/* Check for TMSS */
	andi.b	#0x0f, d0
	beq	1f	/* If version 0, skip TMSS */
	move.l	#0x53454741, IO_TMSS	/* Write 'SEGA' to TMSS port */

	/* Z80 INIT */
	move.w  #0x100, Z80_BUSREQ
	move.w  #0x100, Z80_RESET
1:btst	#0,  Z80_BUSREQ
	bne.s	1b

	lea     z80_init_program, a0
	lea     Z80_ADDR, a1
	move.w  #(z80_init_program_len - 1), d7
1:move.b  (a0)+,(a1)+	 /* data writes to Z80 are byte size */
	dbf	d7, 1b

	move.w  #0, Z80_RESET
	move.w  #0, Z80_BUSREQ
	move.w  #0x100, Z80_RESET
	
	/* set up initial register values */
	lea VDP_CTRL, a5

	move.w #0x8000, d5		/* start at first register */
	move.w #0x0100, d7		/* each register addr is offset by 0x100 */

	moveq #0x12, d0				/* 0x17 registers */
	lea vdp_init_regs, a0

1:move.b (a0)+, d5
	move.w d5, (a5)
	add.w d7, d5
	dbra d0, 1b

	# manually setting cached reg values for now
	# TODO clean this up
	moveq #0, d0
	move.b #0x11, d0
	jsr vdp_set_plane_size
	move.b #(VDP_SCROLLA_NMTBL >> 10), (vdp_nmtbl_plane_a)
	move.b #(VDP_SCROLLB_NMTBL >> 13), (vdp_nmtbl_plane_b)
	/* set plane width mirror in memory for print functions */
	move.b #0, plane_width
	
	jsr init_inputs

	/* and on with the show... */
	INTERRUPT_ENABLE
	rts

/*


NEXT GOALS!!

generalized "set x/y addr" subroutine in vdp

and then fix print





*/