/*
	Mega Drive Video Display Processor (VDP)
*/

.section .text

/* Ports & Registers */
.equ	VDP_DATA,			0xC00000  /* 16 bit r/w */
.equ	VDP_CTRL,			0xC00004  /* 16 bit r/w */
.equ	VDP_HVCOUNT,  0xC00008  /* 16 bit r */
.equ	VDP_DEBUG,    0xC0001C

/*
	VDP Register Word
	This is the register specificier formatted for use on the control port. The
	value should be OR'ed against a value with the register data to write in the
	lower hald of the word
*/
.equ VDP_REG00, 0x8000
.equ VDP_REG01, 0x8100
.equ VDP_REG02, 0x8200
.equ VDP_REG03, 0x8300
.equ VDP_REG04, 0x8400
.equ VDP_REG05, 0x8500
.equ VDP_REG06, 0x8600
.equ VDP_REG07, 0x8700
.equ VDP_REG08, 0x8800
.equ VDP_REG09, 0x8900
.equ VDP_REG0A, 0x8A00
.equ VDP_REG0B, 0x8B00
.equ VDP_REG0C, 0x8C00
.equ VDP_REG0D, 0x8D00
.equ VDP_REG0E, 0x8E00
.equ VDP_REG0F, 0x8F00
.equ VDP_REG10, 0x9000
.equ VDP_REG11, 0x9100
.equ VDP_REG12, 0x9200
.equ VDP_REG13, 0x9300
.equ VDP_REG14, 0x9400
.equ VDP_REG15, 0x9500
.equ VDP_REG16, 0x9600
.equ VDP_REG17, 0x9700

/* Helper constants */
/* These should be OR'ed to the VDP formatted address */
.equ CRAM_WRITE,  0xC0000000
.equ VRAM_WRITE,  0x40000000
.equ VSRAM_WRITE, 0x40000010
.equ CRAM_READ,   0x00000020
.equ VRAM_READ,   0x00000000
.equ VSRAM_READ,  0x00000010

/*
	CALC_NMTBL_ADDR_PLANE_A
	Generates the normalized address for the Plane A name table using the cached
	VDP register value
*/
.macro CALC_NMTBL_ADDR_PLANE_A dreg
	move.b vdp_nmtbl_plane_a, \dreg
	lsl.l #8, \dreg
	lsl.l #2, \dreg
.endm

/*
	CALC_NMTBL_ADDR_PLANE_B
	Generates the standard address for the Plane A name table using the cahced VDP
	register value
*/
.macro CALC_NMTBL_ADDR_PLANE_B dreg
	move.b (vdp_nmtbl_plane_b), \dreg
	lsl.l #8, \dreg
	lsl.l #5, \dreg
.endm

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

# This is a "quasi" function that will set a symbol called vdp_addr with
# the properly formatted address for use on the VDP control port
.macro VDP_ADDR addr,ram,cmd
	.set vdp_addr, 
	(((\ram & \cmd) & 3) << 30) | 
	((\addr & 0x3FFF) << 16) | 
	(((\ram & \cmd) & 0xFC) << 2) | 
	((\addr & 0xC000) >> 14)
.endm

################################################################################
# VDP DMA TRANSFER
# Macros and subroutines for doing DMA transfers
# Note that there is a bug in the hardware when usng Mega CD Word RAM or when
# using the SVP chip. In short, the source address will be off by one, starting
# the read 1 word before the actual address. The solution is to 
################################################################################

/*
	VDP_DMA_TRANSFER
	Load data to VDP via DMA using static values

	BREAK:
	 a5
*/
.macro VDP_DMA_TRANSFER source,dest,length,ram
	lea	(VDP_CTRL).l,a5
	VDP_ADDR \dest,\ram,DMA
	move.l	#((0x9400|((((\length)>>1)&0xFF00)>>8))<<16)|(0x9300|(((\length)>>1)&0xFF)),(a5)
	move.l	#((0x9600|((((\source)>>1)&0xFF00)>>8))<<16)|(0x9500|(((\source)>>1)&0xFF)),(a5)
	move.w	#0x9700|(((((\source)>>1)&0xFF0000)>>16)&0x7F),(a5)
	move.w	#((vdp_cmd>>16)&0xFFFF),(a5)
	move.w	#(vdp_cmd&0xFFFF),(DMA_trigger_word).w
	# we want to write the last word from RAM due to a bug in the hardware
	# see the documentation for more info
	move.w	(DMA_trigger_word).w,(a5)
.endm

/*
  vdp_dma_fill_sub

	IN:
	 d0 - dest addr (VDP_ADDR formatted)
	 d1 - length
	 d2 - value
	BREAK:
	 a5
*/
.global vdp_dma_fill_sub
vdp_dma_fill_sub:
	move.w  #0x100, Z80_BUSREQ
1:btst	#0,  Z80_BUSREQ
	bne.s	1b

	lea VDP_CTRL, a5

	# length is counted in words, so divide by 2...
	lsr.l #1, d1
	and.l #0x7fffffff, d0

	# load dma length
	move.w #0x9300, d3
	move.b d1, d3
	swap d3
	move.w #0x9400, d3
	lsr.w #8, d1
	move.b d1, d3
	move.l d3, (a5)

	# set vram fill
	move.w #0x9500, (a5)
	move.w #0x9600, (a5)
	move.w #0x9780, (a5)

	# set dest addr
	move.l d0, (a5)

	# setup fill value and trigger dma write
	# move fill value to upper half of word
	lsl.w #8, d2
	move.w d2, VDP_DATA

	rts

/*
	vdp_dma_transfer_sub
	Load data to VDP via DMA using dynamic values

	IN:
	 d0 - source addr
	 d1 - length
	 d2 - dest addr (VDP_ADDR formatted)
	BREAK:
	 a5
*/
.global vdp_dma_transfer_sub
vdp_dma_transfer_sub:
	PUSHM d0-d3/a5
	# stop z80
	move.w  #0x100, Z80_BUSREQ
1:btst	#0,  Z80_BUSREQ
	bne.s	1b

	lea VDP_CTRL, a5

	# enable dma
	#move.w #0x811d, (a5)
	
	# length/source are counted in words, so divide by 2...
	lsr.l #1, d1
	lsr.l #1, d0
	and.l #0x7fffffff, d0

	# load dma length
	move.w #0x9300, d3
	move.b d1, d3
	swap d3
	move.w #0x9400, d3
	lsr.w #8, d1
	move.b d1, d3
	move.l d3, (a5)
	
	# load dma source address
	move.w #0x9500, d3
	move.b d0, d3
	swap d3
	lsr.l #8, d0
	move.w #0x9600, d3
	move.b d0, d3
	move.l d3, (a5)
	lsr.l #8, d0
	move.w #0x9700, d3
	move.b d0, d3
	move.w d3, (a5)

	# set address and trigger dma write
	move.w d2, (dma_trigger)
	swap d2
	move.w d2, (a5)
	move.w (dma_trigger), (a5)

	# disable dma
	#move.w #0x8119, (a5)

	move.w  #0, Z80_BUSREQ
	POPM d0-d3/a5
	rts

/*
	vdp_set_plane_size
	Sets size of Plane A & B
	
	IN:
		d0 - Plane size byte
	BREAK:
		d6
*/
vdp_set_plane_size:
	# clean up d0 just in case
	and.l #0x33, d0
	move.b d0, vdp_plane_size
	move.l d0, d6
	or.w #VDP_REG10_PLANESIZE, d0
	move.w d0, VDP_CTRL
	# move the width/height into their own values
	
	# the width/height values act as shift values so we can calculate the size by
	# shifting 1 by the number specified to get the proper size
	move.b d6, d0
	and.l #0x03, d0
	cmp.b #0x03, d0
	bne 1f
	move.b #0x02, d0
1:move.b d0, vdp_plane_width
	lsr.b #4, d6
	cmp.b 0x03, d6
	bne 2f
	move.b 0x02, d6
2:move.b d6, vdp_plane_height
	rts

/*
 * vram_clear
 * Clears entire VRAM
 */
.global vram_clear
vram_clear:
	moveq #0, d0
	move.l #VRAM_WRITE, VDP_CTRL
	move.l #0x3fff, d7
1:move.l d0, VDP_DATA
	dbra d7, 1b
  rts

/*
 * cram_clear
 * Clears entire CRAM
 */
.global cram_clear
cram_clear:
	moveq #0, d0
	move.l #CRAM_WRITE, VDP_CTRL
	move.l #31, d7
1:move.l d0, VDP_DATA
	dbra d7, 1b
	rts

.global vdp_load_registers_c
vdp_load_registers_c:
	movea.l	4(sp), a0

/*
 * vdp_load_registers
 * Load values into all VDP registers
 * IN:
 * a0 - ptr to array of register data
 */
.global vdp_load_registers
vdp_load_registers:
	lea VDP_CTRL, a1

	move.w #0x8000, d5		/* start at first register */
	move.w #0x100, d7		/* each register addr is offset by 0x100 */

	moveq #0x17, d0				/* 0x18 registers */

1:move.b (a0)+, d5
	move.w d5, (a1)
	add.w d7, d5
	dbra d0, 1b

	# TODO THE BELOW IS TEMPORARY, REMOVE IT
		moveq #0, d0
	move.b #0x11, d0
	jsr vdp_set_plane_size
	move.b #(VDP_SCROLLA_NMTBL >> 10), (vdp_nmtbl_plane_a)
	move.b #(VDP_SCROLLB_NMTBL >> 13), (vdp_nmtbl_plane_b)
  rts


.global vram_load_tiles_c
vram_load_tiles_c:
	movea.l	4(a7), a0
	move.l	8(a7), d0
	move.l	0xc(a7), d1

/*
 * vram_load_tiles
 * Load tiles into vram
 * (Data length should be divisible by 4,
 * which shouldn't be a problem if the data
 * is valid tiles)
 * IN:
 * a0 - ptr to tile data
 * d0 - number of tiles
 * d1 - VRAM offset in which to load data (in tiles)
 */
vram_load_tiles:
	/* shift vram offset (tile count * 32) */
	lsl.l #5, d1
	# generate correct addr format
	CALC_VDP_CTRL_ADDR d1 d6
	# set VRAM write bit
	or.l #VRAM_WRITE, d1
	move.l d1, VDP_CTRL
	# each tile is 32 bytes, tile count * 32 (lshift 5)
	# divide by 4 (rshift 2) since we're sending longs
	lsl.l #3, d0

1:move.l (a0)+, VDP_DATA
	dbra d0, 1b

	rts

.global cram_load_palette_c
cram_load_palette_c:
	movea.l	4(a7), a0
	move.l	8(a7), d0
	move.l	0xc(a7), d1

/*
 * cram_load_palette
 * Load palette data into CRAM
 * IN:
 *  a0 - ptr to color data
 *  d0 - count of color entries
 *  d1 - CRAM entry offset (in colors)
 */
cram_load_palette:
	# 2 bytes per color
	lsl.l #1, d1
  CALC_VDP_CTRL_ADDR d1 d6
	# set CRAM write bit
	or.l #CRAM_WRITE, d1
	move.l d1, VDP_CTRL
1:move.w (a0)+, VDP_DATA
	dbra d0, 1b
	rts

#.global vblank_wait
#vblank_wait:
	lea vblank_flag, a6		/* check our vblank flag*/
1:move.b (a6), d0		/* MOVE will set Z flag if the value is 0 */
	beq 1b
	move.b #0, (a6)		/* reset flag and return to processing */
	rts

#vblank_int:
	addq.b   #1, (vblank_flag)	/* vblank occurred; set flag */
	rte

/*
	IN:
	d0 - x/y pos (x upper byte, y lower byte)

	OUT:
	d0 - offset to x/y pos
	d1 - number of tiles per row
*/
.global vdp_xy_pos
vdp_xy_pos:
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

# the plane size is a little unintuitive to work with, so we also have seperate
# width and heightsettings which uses the lowest three bits for each mode
# (0 - 32 tiles, 1 - 64 tiles, 2 - 128 tiles)
vdp_plane_size: .byte 0
vdp_plane_width: .byte 0
vdp_plane_height: .byte 0
vdp_nmtbl_plane_a: .byte 0
vdp_nmtbl_plane_b: .byte 0
vdp_nmtbl_window: .byte 0
vdp_sprtbl: .byte 0
.global vblank_flag
vblank_flag: .byte 0
dma_trigger: .word 0
.align 2
