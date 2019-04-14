/* Initial environment settings */

/* VDP SETTINGS */
/* Addresses for name tables */
.equ VDP_SCROLLA_PTBL,  0xC000
.equ VDP_WINDOW_PTBL,   0xB000
.equ VDP_SCROLLB_PTBL,  0xA000
.equ VDP_SPR_ATBL,      0xE000
.equ VDP_HSCROLL,				0xD000

.section .rodata
/* Initial VDP register values */
vdp_init_regs:
	dc.b 0b00000100 | 00: Mode Register 1
	dc.b 0b01110100 | 01: Mode Register 2
	dc.b (VDP_SCROLLA_PTBL >> 10) | 02: Plane A Name Table Address
	dc.b (VDP_WINDOW_PTBL >> 10) | 03: Window Name Table Address
	dc.b (VDP_SCROLLB_PTBL >> 13) | 04: Plane B Name Table Address
	dc.b (VDP_SPR_ATBL >> 9) | 05: Sprite Table Address
	dc.b 0x00 | 06: Bit 16 of Sprite Table Address for 128k VRAM
	dc.b 0b00000000 | 07: Background color
	dc.b 0x00 | 08: Unused (Mark III Horiz Scroll Register)
	dc.b 0x00 | 09: Unused (Mark III Vert Scroll Register)
	dc.b 0x00 | 0A: Horiz Interrupt Counter
	dc.b 0x08 | 0B: Mode Register 3
	dc.b 0b00000000 | 0C: Mode Register 4
	dc.b (VDP_HSCROLL >> 10) | 0D: Horiz. scroll table at 0xD000 (bits 0-5)
	dc.b 0x00 | 0E: Plane A/B Name Table Address bits for 128k VRAM
	dc.b 0x02 | 0F: Autoincrement value
	dc.b 0b00000000 | 10: Plane Size
	dc.b 0x00 | 11: Window Plane X pos
	dc.b 0x00 | 12: Window Plane Y pos
	dc.b 0x00 | 13: DMA Length lo byte
	dc.b 0x00 | 14: DMA Length hi byte
	dc.b 0x00 | 15: DMA Source Address lo byte
	dc.b 0x00 | 16: DMA Source Address mid byte
	dc.b 0x00 | 17: DMA Source Address hi byte & DMA Mode
.align 2

