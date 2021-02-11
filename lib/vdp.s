/**
 * \file vdp.s
 * Mega Drive Video Display Processor (VDP)
 */

#ifndef MEGADEV__VDP_S
#define MEGADEV__VDP_S

#include "vdp_def.h"

.section .text

/*
	CALC_VDP_CTRL_ADDR
	Generates the VDP formatted address for use on the control port
	This only works with the address, the write/read bits will need to be set
	after
	IN:
		dreg_addr - data register containing address
		dreg_work - register which can be used for calculation
	BREAK:
		dreg_work
*/
/*
.macro CALC_VDP_CTRL_ADDR dreg_addr dreg_work
	# move lower word to upper
	swap \dreg_addr
	move.l \dreg_addr, \dreg_work
	
	# rotate upper two bits into lower two
	rol.l #2, \dreg_addr
	and.l #3, \dreg_addr
	or.l \dreg_work, \dreg_addr
	# clear irrelevant bits
	and.l #0x3fff0003, \dreg_addr
.endm
*/

/*
	Converts an address in the specifed D register to
	VDP ctrl port format
	After which, the control port constants below can be OR'ed against
	it to set up its functionality
*/
.macro MAKE_VDP_ADDR dreg
	and.l #0xffff, \dreg
	lsl.l #2, \dreg
	lsr.w #2, \dreg
	swap \dreg
.endm

/* VDP control port address helper constants */
/* These should be OR'ed to the VDP formatted address */
.equ VRAM_READ,   0x00000000
.equ VRAM_WRITE,  0x40000000
.equ CRAM_READ,   0x00000020
.equ CRAM_WRITE,  0xC0000000
.equ VSRAM_READ,  0x00000010
.equ VSRAM_WRITE, 0x40000010

.equ USE_DMA, 0x80
.equ VRAM_TO_VRAM, 0x40

.equ VRAM_WRITE_DMA, (VRAM_WRITE | USE_DMA)
.equ CRAM_WRITE_DMA, (CRAM_WRITE | USE_DMA)


/*
	Register helpers
	These are wrappers for setting commonly used VDP registers
	Note that we can *not* read from VDP registers, so we cache these registers
	settings to RAM. You are free to use your own VDP register strategy and not
	use any cached values, but keep in mind some MEGADEV functionality (such as
	the tilemap system) uses these values to work properly.
*/

/*
	Valid plane sizes (in tiles)
*/
.equ VDP_PLANE_SIZE_32x32,  0x00
.equ VDP_PLANE_SIZE_32x64,  0x01
.equ VDP_PLANE_SIZE_32x128, 0x03
.equ VDP_PLANE_SIZE_64x32,  0x10
.equ VDP_PLANE_SIZE_64x64,  0x11
.equ VDP_PLANE_SIZE_128x32, 0x30

################################################################################
# VDP ADDRESS SET
# Macros and subroutines for generating VDP formatted control port command
################################################################################

# VDP target RAM
.equ VRAM,  0b00100001
.equ CRAM,  0b00101011
.equ VSRAM, 0b00100101

# Data command
.equ READ,  0b00001100
.equ WRITE, 0b00000111
.equ DMA,   0b00100111

.altmacro
.macro SET_VDP_ADDR addr:req bus:req op:req
	#move.l ((( 0x01 & 0x02) & 3) << 30), (\dest)
	.set vdp_addr, ((((\bus & \op) & 3) << 30) | ((\addr & 0x3FFF) << 16) | (((\bus & \op) & 0xFC) << 2) | ((\addr & 0xC000) >> 14))
.endm

FUNC get_tiles_per_row
	move.b vdp_plane_size, d2
	and.w #3, d2
	# find number of tiles per row
	moveq #32, d1
	cmp.b #3, d2
	bne 1f
	and.b #2, d2
1:lsl.w d2, d1
  rts

/*

	IN:
	 d0 - x/y pos (x upper byte, y lower byte)

	OUT:
	 d0 - offset to x/y pos
	 d1 - number of tiles per row

	BREAK:
	 d2
*/
FUNC vdp_xy_pos
	move.b vdp_plane_size, d2
	and.w #3, d2
	# find number of tiles per row
	moveq #32, d1
	cmp.b #3, d2
	bne 1f
	and.b #2, d2
1:lsl.w d2, d1
	# d1 contains number of tiles per row
	move.b d0, d2
	and.w #0x00ff, d2
	# d2 now has y pos
	mulu d1, d2
	# d2 is now y pos * tiles per row
	lsr.w #8, d0
	# add x pos
	add.w d0, d2
	# multiply by 2 for tilemap entry size
	lsl.l #1, d2
	move.l d2, d0
	rts


.section .bss
vdp_plane_size: .byte 0
.align 2
dma_trigger: .word 0

#endif
