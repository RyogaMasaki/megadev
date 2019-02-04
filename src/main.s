.include "boot.s"
.include "vdp.s"

.text
/* Your program code starts here */
.align 4
main2:
move    #0x2000, %sr
jsr vdpInit
jsr setupPalette
jsr setupFont

mainLoop:
	move.w #0x8F02, VDP_CTRL_PORT
	move.l #0x40000003, VDP_CTRL_PORT
	move.w #0x0008, VDP_DATA_PORT
	move.w #0x0005, VDP_DATA_PORT
	move.w #0x000c, VDP_DATA_PORT
	move.w #0x000c, VDP_DATA_PORT
	move.w #0x000f, VDP_DATA_PORT
	jsr waitVBlank
	jmp mainLoop

_end:
