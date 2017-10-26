.global _start

_start:
.include "boot.s"

/* Your program code starts here */
__MAIN:

	mainLoop:
	jmp mainLoop

__END:
