.include "boot.s"

.text
/* Your program code starts here */
__MAIN:

move    #0x2000, %sr
jsr initVDP
jmp mainLoop

waitVBlank:
	move.l	#vblank, %a6
	move.l (%a6), %d0
1:move.l (%a6), %d1
	cmp.l %d0, %d1
	beq 1b
	move.b #0, (%a6)
	rts

initVDP:
	move.l #VDP_CTRL_PORT, %a4
	move.l #VDP_DATA_PORT, %a5

	move.w #0x8000, %d5
	move.w #0x0100, %d7

	moveq #18, %d0
	lea vdpRegs, %a0

1:move.b (%a0)+, %d5
	move.w %d5, (%a4)
	add.w %d7, %d5
	dbra %d0, 1b

	move.l  #0xC0000000, (%a5)
	move.w  #0x8F02, (%a5)

	moveq #31, %d0
	lea Palettes, %a0

2:move.w (%a0)+, (%a4)
	dbra %d0, 2b

	rts

	mainLoop:
	jsr waitVBlank

	jmp mainLoop

	Palettes:
	.word   0x0000  | Color 0 is always transparent
	.word   0x00EE  | Yellow
	.word   0x0E00  | Blue
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	
	.word   0x0000  | Color 0 is always transparent
	.word   0x0000  | Black
	.word   0x0EEE  | White
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red
	.word   0x000E  | Red


vdpRegs:
.byte   0x04    | Reg.  0: Enable Hint, HV counter stop
.byte   0x74    | Reg.  1: Enable display, enable Vint, enable DMA, V28 mode (PAL & NTSC)
.byte   0x30    | Reg.  2: Plane A is at 0xC000
.byte   0x40    | Reg.  3: Window is at 0x10000 (disable)
.byte   0x07    | Reg.  4: Plane B is at 0xE000
.byte   0x6A    | Reg.  5: Sprite attribute table is at 0xD400
.byte   0x00    | Reg.  6: always zero
.byte   0x03    | Reg.  7: Background color: palette 0, color 0
.byte   0x00    | Reg.  8: always zero
.byte   0x00    | Reg.  9: always zero
.byte   0x00    | Reg. 10: Hint timing
.byte   0x08    | Reg. 11: Enable Eint, full scroll
.byte   0x81    | Reg. 12: Disable Shadow/Highlight, no interlace, 40 cell mode
.byte   0x34    | Reg. 13: Hscroll is at 0xD000
.byte   0x00    | Reg. 14: always zero
.byte   0x00    | Reg. 15: no autoincrement
.byte   0x01    | Reg. 16: Scroll 32V and 64H
.byte   0x00    | Reg. 17: Set window X position/size to 0
.byte   0x00    | Reg. 18: Set window Y position/size to 0
.byte   0x00    | Reg. 19: DMA counter low
.byte   0x00    | Reg. 20: DMA counter high
.byte   0x00    | Reg. 21: DMA source address low
.byte   0x00    | Reg. 22: DMA source address mid
.byte   0x00    | Reg. 23: DMA source address high, DMA mode ?


.data

_end:
