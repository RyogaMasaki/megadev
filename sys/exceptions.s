.text
/* Error Exception implementations */
_exBUS:
	lea strBUSERR, a0
	jmp handle_exception

_exADDRESS:
	lea strADDRERR, a0
	jmp handle_exception

_exILLEGAL:
	lea strILLEGAL, a0
	jmp handle_exception

_exZERO:
	lea strZERODIV, a0
	jmp handle_exception

_exCHKINST:
	lea strCHKINST, a0
	jmp handle_exception

_exTRAPV:
	lea strTRAPV, a0
	jmp handle_exception

_exPRIV:
	lea strPRIVV, a0
	jmp handle_exception

_exTRACE:
	lea strTRACE, a0
	jmp handle_exception

_exLINE1010:
	lea strL1010, a0
	jmp handle_exception

_exLINE1111:
	lea strL1111, a0
	jmp handle_exception

_exSPUR:
	lea strSPUR, a0
	jmp handle_exception

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
	moveq #1, d0
	moveq #1, d1
	jsr print				| print exception type as defined above
	PRINT strPC, #1, #2
	moveq #4, d0
	moveq #2, d1
	move.l 0xa(sp), d2	| PC is 0ffset 0xa from interrupt stack pointer
	jsr printval32_long

	PRINT strSR, #1, #3
	moveq #4, d0
	moveq #3, d1
	move.w 0x8(sp), d2 	| SR is offset 0x8
	jsr printval32_word

	PRINT strADDR, #1, #4
	moveq #6, d0
	moveq #4, d1
	move.l 0x2(sp), d2 | access address is offset 0x2
	jsr printval32_long

	PRINT strOPC, #1, #5
	moveq #8, d0
	moveq #5, d1
	move.w 0x6(sp), d2 | opcode is offset 0x6
	jsr printval32_word

	stop #0x2700

.section .rodata
strBUSERR:  .asciz "BUS ERROR"
strADDRERR: .asciz "ADDRESS ERROR"
strILLEGAL: .asciz "ILLEGAL INSTRUCTION"
strZERODIV: .asciz "ZERO DIVIDE"
strCHKINST: .asciz "CHK INSTRUCTION"
strTRAPV:   .asciz "TRAPV"
strPRIVV:   .asciz "PRIVELEGE VIOLATION"
strTRACE:   .asciz "TRACE"
strL1010:   .asciz "LINE 1010 EMULATOR"
strL1111:   .asciz "LINE 1111 EMULATOR"
strSPUR:    .asciz "SPURIOUS"

strPC:   .asciz "PC="
strSR:   .asciz "SR="
strADDR: .asciz "ADDR="
strOPC:  .asciz "OPCODE="

