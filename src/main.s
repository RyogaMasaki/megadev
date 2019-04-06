.include "boot.s"
.include "vdp.s"

.text
/* Your program code starts here */
.align 4
main:
move    #0x2000, %sr
jsr vdpInit
jsr loadPalette
jsr loadFont

lea helloWorld, %a0
jsr drawString32

lea helloWorld2, %a0
jsr drawString32

mainLoop:
	
	jsr waitVBlank
	move.l #0x50000003, VDP_CTRL_PORT
  move.w %d4, VDP_DATA_PORT
  add.w  #1,%d4
	jmp mainLoop

helloWorld:
	dc.b 0
	dc.b 14
	.ascii " Hello World! :)"
	dc.b 0

helloWorld2:
	dc.b 3
	dc.b 10
	.ascii " Hello World! :)"
	dc.b 0

_end:
