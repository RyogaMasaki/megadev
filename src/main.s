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

lea helloWorld, %a0
jsr drawString

mainLoop:
	
	jsr waitVBlank
	jmp mainLoop

helloWorld:
	.ascii " Hello World! :)"
	dc.b 0

_end:
