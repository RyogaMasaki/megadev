
/* VDP Definitions */
/* http://md.squee.co/VDP */

.equ	VDP_DATA_PORT,   0xC00000
.equ	VDP_CTRL_PORT,   0xC00004
.equ	VDP_HV_COUNT,    0xC00008
.equ	VDP_DEBUG,       0xC0001C

.equ	VDP_REG_0,	0x8000
.equ	VDP_REG_1,	0x8100
.equ	VDP_REG_7,	0x8700
.text

vdpInit:
	lea VDP_CTRL_PORT, %a4
	lea VDP_DATA_PORT, %a5

	move.w #0x8000, %d5
	move.w #0x0100, %d7

	moveq #18, %d0
	lea vdpInitRegisters, %a0

1:move.b (%a0)+, %d5
	move.w %d5, (%a4)
	add.w %d7, %d5
	dbra %d0, 1b
	rts

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
	move.w #0x8F02, VDP_CTRL_PORT   | Set autoincrement to 2 bytes
	move.l #0xC0000003, VDP_CTRL_PORT | Set up VDP to write to CRAM address 0x0000
	lea sysPalette, %a0          | Load address of Palette into a0
	move.l #0x07, %d0         | 32 bytes of data (8 longwords, minus 1 for counter) in palette
 
	1:
	move.l (%a0)+, 0x00C00000 | Move data to VDP data port, and increment source address
	dbra %d0, 1b
	rts

/* Initial VDP register values */
/* https://bigevilcorporation.co.uk/2012/03/23/sega-megadrive-4-hello-world/ */
vdpInitRegisters:
	dc.b 0x20 | 0: Horiz. interrupt on, plus bit 2 (unknown, but docs say it needs to be on)
	dc.b 0x74 | 1: Vert. interrupt on, display on, DMA on, V28 mode (28 cells vertically), + bit 2
	dc.b 0x30 | 2: Pattern table for Scroll Plane A at 0xC000 (bits 3-5)
	dc.b 0x40 | 3: Pattern table for Window Plane at 0x10000 (bits 1-5)
	dc.b 0x05 | 4: Pattern table for Scroll Plane B at 0xA000 (bits 0-2)
	dc.b 0x70 | 5: Sprite table at 0xE000 (bits 0-6)
	dc.b 0x00 | 6: Unused
	dc.b 0x00 | 7: Background colour - bits 0-3 = colour, bits 4-5 = palette
	dc.b 0x00 | 8: Unused
	dc.b 0x00 | 9: Unused
	dc.b 0x00 | 10: Frequency of Horiz. interrupt in Rasters (number of lines travelled by the beam)
	dc.b 0x08 | 11: External interrupts on, V/H scrolling on
	dc.b 0x81 | 12: Shadows and highlights off, interlace off, H40 mode (40 cells horizontally)
	dc.b 0x34 | 13: Horiz. scroll table at 0xD000 (bits 0-5)
	dc.b 0x00 | 14: Unused
	dc.b 0x00 | 15: Autoincrement off
	dc.b 0x01 | 16: Vert. scroll 32, Horiz. scroll 64
	dc.b 0x00 | 17: Window Plane X pos 0 left (pos in bits 0-4, left/right in bit 7)
	dc.b 0x00 | 18: Window Plane Y pos 0 up (pos in bits 0-4, up/down in bit 7)
	dc.b 0x00 | 19: DMA length lo byte
	dc.b 0x00 | 20: DMA length hi byte
	dc.b 0x00 | 21: DMA source address lo byte
	dc.b 0x00 | 22: DMA source address mid byte
	dc.b 0x00 | 23: DMA source address hi byte, memory-to-VRAM mode (bits 6-7)

sysPalette:
	/* https://bigevilcorporation.co.uk/2012/03/23/sega-megadrive-4-hello-world/ */
	dc.w 0x0000 | Colour 0 - Transparent
	dc.w 0x000E | Colour 1 - Red
	dc.w 0x00E0 | Colour 2 - Green
	dc.w 0x0E00 | Colour 3 - Blue
	dc.w 0x0000 | Colour 4 - Black
	dc.w 0x0EEE | Colour 5 - White
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

	CharacterH:
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11111110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x11000110
   dc.l 0x00000000

.data
	vblank: .byte 0
