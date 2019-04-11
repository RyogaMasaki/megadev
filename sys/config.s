/* Initial environment settings */

/* VDP SETTINGS */
/* Addresses for name tables */
.equ VDP_SCROLLA_PTBL,  0xC000
.equ VDP_WINDOW_PTBL,   0xB000
.equ VDP_SCROLLB_PTBL,  0xA000
.equ VDP_SPR_ATBL,      0xE000

/* Initial VDP register values */
vdp_init_regs:
	dc.b 0b00000100 | 00: Horiz. interrupt off, standard color mode
	dc.b 0b01110100 | 01: Vert. interrupt on, display on, DMA on, V28 mode, Megadrive display mode
	dc.b 0b00110000 | 02: Pattern table for Scroll Plane A at 0xC000 (bits 3-5)
	dc.b 0b00101100 | 03: Pattern table for Window Plane at 0xB000 (bits 1-5)
	dc.b 0x05 | 04: Pattern table for Scroll Plane B at 0xA000 (bits 0-2)
	dc.b 0x70 | 05: Sprite table at 0xE000 (bits 0-6)
	dc.b 0x00 | 06: Unused here
	dc.b 0b00000010 | 07: Background colour - bits 0-3 = colour, bits 4-5 = subpalette
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

.align 2

