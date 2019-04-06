.macro VRAM_READ addr
	move.l #0x00000000 + ((\addr & 0x3FFF) << 16) + ((\addr & 0xC000) >> 14), VDP_CTRL_PORT
.endm

.macro VRAM_WRITE addr
	move.l #0x40000000 + ((\addr & 0x3FFF) << 16) + ((\addr & 0xC000) >> 14), VDP_CTRL_PORT
.endm

.macro VRAM_WRITE_D6 addr
	move.l #0x40000000 + ((\addr & 0x3FFF) << 16) + ((\addr & 0xC000) >> 14), %d6
.endm

.macro CRAM_READ addr
	move.l #0x00000020 + (\addr << 16), VDP_CTRL_PORT
.endm

.macro CRAM_WRITE addr
	move.l #0xC0000000 + (\addr << 16), VDP_CTRL_PORT
.endm

.macro VSRAM_READ addr
	move.l #0x00000010 + (\addr << 16), VDP_CTRL_PORT
.endm

.macro VSRAM_WRITE addr
	move.l #0x40000010 + (\addr << 16), VDP_CTRL_PORT
.endm

/* Register 0x00 */
.macro VDP_MODEREG1 val
	move.w #0x8000 + \val, VDP_CTRL_PORT
.endm

/* Register 0x01 */
.macro VDP_MODEREG2 val
	move.w #0x8100 + \val, VDP_CTRL_PORT
.endm

/* Register 0x02 */
/* Plane A Name Table Location */
.macro VDP_NAMETB_PA val
	move.w #0x8200 + (\val >> 10), VDP_CTRL_PORT
.endm

/* Register 0x03 */
/* Window Name Table Location */
.macro VDP_NAMETB_W val
	move.w #0x8300 + (\val >> 10), VDP_CTRL_PORT
.endm

/* Register 0x04 */
/* Plane B Name Table Location */
.macro VDP_NAMETB_PB
	move.w #0x8400 + (\val >> 13), VDP_CTRL_PORT
.endm

/* Register 0x05 */
/* Sprite Table Location */
.macro VDP_SPRTB
	move.w #0x8500 + (\val >> 9), VDP_CTRL_PORT
.endm

/* Register 0x07 */
/* pl - Palette line */
/* col - Palette index */
.macro VDP_BGCOLOR pl col
	move.w #0x8500 + (\pl << 4) + \col, VDP_CTRL_PORT
.endm

/* Register 0x0F */
.macro VDP_AUTOINC val
	move.w #0x8F00 + \val, VDP_CTRL_PORT
.endm

/* VDP Definitions */
/* http://md.squee.co/VDP */

.equ	VDP_DATA_PORT,   0xC00000  | 8/16 bit r/w
.equ	VDP_CTRL_PORT,   0xC00004  | 8/16 bit r/w
.equ	VDP_HV_COUNT,    0xC00008  | 8/16 bit r
.equ	VDP_DEBUG,       0xC0001C
.text

vdpInit:
	VRAM_WRITE 0xA000
	move.w #0x3000, %d0
1:move.w #0, VDP_DATA_PORT
	dbra %d0, 1b
	
	lea VDP_CTRL_PORT, %a5

	move.w #0x8000, %d5		| start at first register
	move.w #0x0100, %d7		| each register addr is offset by 0x100

	moveq #18, %d0				| 0x17 registers
	lea vdpInitRegisters, %a0

1:move.b (%a0)+, %d5
	move.w %d5, (%a5)
	add.w %d7, %d5
	dbra %d0, 1b
	rts

.global waitVBlank
waitVBlank:
	lea vblank, %a6
	move.l (%a6), %d0
1:move.l (%a6), %d1
	cmp.l %d0, %d1
	beq 1b
	move.b #0, (%a6)
	rts

vBlankInt:
	addq.b   #1, (vblank)
	rte

setupPalette:
	/* vdp auto increment should be set to 2 already */
	CRAM_WRITE 0
	lea sysPalette, %a0          | Load address of Palette into a0 
	move.l #0x07, %d0         | 32 bytes of data (8 longwords, minus 1 for counter) in palette
 
	1:
	move.l (%a0)+, VDP_DATA_PORT | Move data to VDP data port, and increment source address
	dbra %d0, 1b
	rts

setupFont:
	/* vdp auto increment should be set to 2 already */
	VRAM_WRITE 0
	lea sysFont, %a0
	move.l #sysFontLen, %d0

	1:
	move.l (%a0)+, VDP_DATA_PORT
	dbra %d0, 1b
	rts

drawString:
	/*
		TO DO: implement tile offset
		a0 - ptr to text
	*/
	move.w #0, %d2
	VRAM_WRITE 0xC000
	1:
	move.b (%a0)+, %d2
	beq 2f
	sub #0x20, %d2
	move.w %d2, VDP_DATA_PORT
	bra 1b
	2:
	rts

/* Initial VDP register values */
/* https://bigevilcorporation.co.uk/2012/03/23/sega-megadrive-4-hello-world/ */
vdpInitRegisters:
	dc.b 0x04 | 00: Horiz. interrupt off, standard color mode
	dc.b 0x74 | 01: Vert. interrupt on, display on, DMA on, V28 mode, Megadrive display mode
	dc.b 0x30 | 02: Pattern table for Scroll Plane A at 0xC000 (bits 3-5)
	dc.b 0x2c | 03: Pattern table for Window Plane at 0xB000 (bits 1-5)
	dc.b 0x05 | 04: Pattern table for Scroll Plane B at 0xA000 (bits 0-2)
	dc.b 0x70 | 05: Sprite table at 0xE000 (bits 0-6)
	dc.b 0x00 | 06: Unused here
	dc.b 0x0A | 07: Background colour - bits 0-3 = colour, bits 4-5 = palette
	dc.b 0x00 | 08: Unused
	dc.b 0x00 | 09: Unused
	dc.b 0x00 | 0A: Frequency of Horiz. interrupt in Rasters (number of lines travelled by the beam)
	dc.b 0x08 | 0B: External interrupts on, V/H fullscreen scrollings
	dc.b 0x81 | 0C: Shadows and highlights off, interlace off, H40 mode (40 cells horizontally)
	dc.b 0x34 | 0D: Horiz. scroll table at 0xD000 (bits 0-5)
	dc.b 0x00 | 0E: Unused here
	dc.b 0x02 | 0F: Autoincrement 2
	dc.b 0x00 | 10: Vert. scroll 32, Horiz. scroll 32
	dc.b 0x00 | 11: Window Plane X pos 0 left (pos in bits 0-4, left/right in bit 7)
	dc.b 0x00 | 12: Window Plane Y pos 0 up (pos in bits 0-4, up/down in bit 7)
	dc.b 0x00 | 13: DMA length lo byte
	dc.b 0x00 | 14: DMA length hi byte
	dc.b 0x00 | 15: DMA source address lo byte
	dc.b 0x00 | 16: DMA source address mid byte
	dc.b 0x00 | 17: DMA source address hi byte, memory-to-VRAM mode (bits 6-7)

sysPalette:
	/* https://bigevilcorporation.co.uk/2012/03/23/sega-megadrive-4-hello-world/ */
	dc.w 0x0000 | Colour 0 - Transparent
	dc.w 0x0EEE | Colour 1 - White
	dc.w 0x0000 | Colour 2 - Black
	dc.w 0x000E | Colour 3 - Red
	dc.w 0x00E0 | Colour 4 - Green
	dc.w 0x0E00 | Colour 5 - Blue
	dc.w 0x00EE | Colour 6 - Yellow
	dc.w 0x008E | Colour 7 - Orange
	dc.w 0x0E0E | Colour 8 - Pink
	dc.w 0x0808 | Colour 9 - Purple
	dc.w 0x0444 | Colour A - Dark grey
	dc.w 0x0888 | Colour B - Light grey
	dc.w 0x0EE0 | Colour C - Turquoise
	dc.w 0x000A | Colour D - Maroon
	dc.w 0x0600 | Colour E - Navy blue
	dc.w 0x0060 | Colour F - Dark green

sysFont:
  .incbin "../etc/font8x8"
	.equ sysFontLen, .-sysFont;

.data
	vblank: .byte 0
