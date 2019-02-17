.include "boot.s"
.include "vdp.s"

.text
/* Your program code starts here */
.align 4
main:
move    #0x2000, %sr
jsr vdpInit
jsr setupPalette
jsr setupFont

lea helloWorld, %a0
moveq #0, %d0
jsr drawString

mainLoop:
	
	jsr waitVBlank
	move.l #0x50000003, VDP_CTRL_PORT
  move.w %d4, VDP_DATA_PORT
  add.w  #1,%d4
	jmp mainLoop

helloWorld:
	.ascii " Hello World! :)"
	dc.b 0

_end:
