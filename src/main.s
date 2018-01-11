.include "boot.s"
.include "vdp.s"

.text
/* Your program code starts here */
__MAIN:
move    #0x2000, %sr
jsr vdpInit
jsr setupPalette

mainLoop:
	jsr waitVBlank
	jmp mainLoop

_end:
