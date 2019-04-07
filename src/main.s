.include "boot.s"
.include "vdp.s"

.text
/* Your program code starts here */
.align 4
main:

jsr vdpInit
jsr loadPalette
jsr loadFont

/* Interrupts are still disabled at this point; enable them */
move    #0x2000, %sr

lea helloWorld, %a0
jsr drawString32

mainLoop:
	jsr waitVBlank
	move.l #0x50000003, VDP_CTRL_PORT
  move.w %d4, VDP_DATA_PORT
  add.w  #1,%d4
	jmp mainLoop

helloWorld:
	dc.b 0, 14
	.asciz "Hello World! :)"

_end:
