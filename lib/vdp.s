.ifndef MEGADEV__VDP_S
.set MEGADEV__VDP_S, 1

/* Mega Drive Video Display Processor (VDP) */

.section .text

/* Ports */
.equ	VDP_DATA,			0xC00000  /* 16 bit r/w */
.equ	VDP_CTRL,			0xC00004  /* 16 bit r/w */
.equ	VDP_HVCOUNT,  0xC00008  /* 16 bit r */

.equ	VDP_DEBUG,    0xC0001C

/*
	VDP Registers
	This is the register specificier formatted for use on the control port. The
	value should be OR'ed against a value with the register data to write in the
	lower half of the word
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

/* Status register bits */
.equ PAL_HARDWARE, 0x0001
.equ DMA_IN_PROGRESS, 0x0002
.equ HBLANK_IN_PROGRESS, 0x0004
.equ VBLANK_IN_PROGRESS, 0x0008
.equ ODD_FRAME, 0x0010
.equ SPR_COLLISION, 0x0020
.equ SPR_LIMIT, 0x0040
.equ VINT_TRIGGERED, 0x0080
.equ FIFO_FULL, 0x0100
.equ FIFO_EMPTY, 0x0200

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

.global get_tiles_per_row
get_tiles_per_row:
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


/*
 * vram_clear
 * Clears entire VRAM
 * BREAK:
 *  d0, d7, a5
 */
.global vdp_vram_clear
vdp_vram_clear:
	lea VDP_DATA, a5
	move.l #VRAM_WRITE, (VDP_CTRL)
	moveq #0, d0
	move.l #0xfff, d7
1:move.l d0, (VDP_DATA)
  move.l d0, (VDP_DATA)
	move.l d0, (VDP_DATA)
	move.l d0, (VDP_DATA)
	dbra d7, 1b

	# also clear vsram
	# (this is for testing, should move to its own subroutine)
	move.l #0x40000010, VDP_CTRL
	move.l #0, (VDP_DATA)
  rts

/*
 * cram_clear
 * Clears entire CRAM
 * BREAK:
 *  d0, d7, a5
 */
.global vdp_cram_clear
vdp_cram_clear:
	moveq #0, d0
	lea VDP_DATA, a5
	move.l #CRAM_WRITE, VDP_CTRL
	move.l #31, d7
1:move.l d0, (a5)
	dbra d7, 1b
	rts

/*
	a0 - ptr to regs (0x18 bytes)
	BREAK:
	d6, d7, a5
*/
.global vdp_load_regs
vdp_load_regs:
	lea VDP_CTRL, a5
	move.w #VDP_REG00, d6
	moveq #0x11, d7
1:move.b (a0)+, d6
	move.w d6, (a5)
	add.w #0x100, d6
	dbf d7, 1b
  rts

/*
d0 - register id
d1 - value
*/
.global vdp_load_reg
vdp_load_reg:
	lsl.w #8, d0
	add.w #VDP_REG00, d0
	add.b d1, d0
	move.w d0, (VDP_CTRL)
  rts

.section .bss
vdp_plane_size: .byte 0
.align 2
dma_trigger: .word 0

.endif
