/* Error Exception implementations */
_exBUS:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "BUS ERROR"

_exADDRESS:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "ADDRESS ERROR"

_exILLEGAL:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "ILLEGAL INSTRUCTION"

_exZERO:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "ZERO DIVIDE"

_exCHKINST:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "CHK INSTRUCTION"

_exTRAPV:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "TRAPV"

_exPRIV:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "PRIVELEGE VIOLATION"

_exTRACE:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "TRACE"

_exLINE1010:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "LINE 1010 EMULATOR"

.align 2
_exLINE1111:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "LINE 1111 EMULATOR"

.align 2
_exSPUR:
	lea 1f, a0
	jmp handle_exception
	1: dc.b 1, 1
	.asciz "SPURIOUS"

.align 2
/* Trap exceptions */

_trap0:
	rte

_trap1:
	rte

_trap2:
	rte

_trap3:
	rte

_trap4:
	rte

_trap5:
	rte

_trap6:
	rte

_trap7:
	rte

_trap8:
	rte

_trap9:
	rte

_trapA:
	rte

_trapB:
	rte

_trapC:
	rte

_trapD:
	rte

_trapE:
	rte

_trapF:
	rte

/* Generic exception handler */
handle_exception:				
	jsr print32
	lockloop:
	jmp lockloop
  
.align 2

