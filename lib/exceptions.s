.section .text
/* Error Exception implementations */
.global _exBUS
_exBUS:
	lea strBUSERR, a0
	jmp handle_exception

.global _exADDRESS
_exADDRESS:
	lea strADDRERR, a0
	jmp handle_exception

.global _exILLEGAL
_exILLEGAL:
	lea strILLEGAL, a0
	jmp handle_exception

.global _exZERO
_exZERO:
	lea strZERODIV, a0
	jmp handle_exception

.global _exCHKINST
_exCHKINST:
	lea strCHKINST, a0
	jmp handle_exception

.global _exTRAPV
_exTRAPV:
	lea strTRAPV, a0
	jmp handle_exception

.global _exPRIV
_exPRIV:
	lea strPRIVV, a0
	jmp handle_exception

.global _exTRACE
_exTRACE:
	lea strTRACE, a0
	jmp handle_exception

.global _exLINE1010
_exLINE1010:
	lea strL1010, a0
	jmp handle_exception

.global _exLINE1111
_exLINE1111:
	lea strL1111, a0
	jmp handle_exception

.global _exSPUR
_exSPUR:
	lea strSPUR, a0
	jmp handle_exception

/* Trap exceptions */
.global _trap0
_trap0:
	rte

.global _trap1
_trap1:
	rte

.global _trap2
_trap2:
	rte

.global _trap3
_trap3:
	rte

.global _trap4
_trap4:
	rte

.global _trap5
_trap5:
	rte

.global _trap6
_trap6:
	rte

.global _trap7
_trap7:
	rte

.global _trap8
_trap8:
	rte

.global _trap9
_trap9:
	rte

.global _trapA
_trapA:
	rte

.global _trapB
_trapB:
	rte

.global _trapC
_trapC:
	rte

.global _trapD
_trapD:
	rte

.global _trapE
_trapE:
	rte

.global _trapF
_trapF:
	rte

/* Generic exception handler */
handle_exception:
	moveq #1, d0
	moveq #1, d1
	jsr print				/* print exception type as defined above */
	PRINT strPC, 1, 2
	moveq #4, d0
	moveq #2, d1
	move.l 0xa(sp), d2	/* PC is 0ffset 0xa from interrupt stack pointer */
	jsr printval_u32

	PRINT strSR, 1, 3
	moveq #4, d0
	moveq #3, d1
	move.w 0x8(sp), d2 	/* SR is offset 0x8 */
	jsr printval_u16

	PRINT strADDR, 1, 4
	moveq #6, d0
	moveq #4, d1
	move.l 0x2(sp), d2 /* access address is offset 0x2 */
	jsr printval_u32

	PRINT strOPC, 1, 5
	moveq #8, d0
	moveq #5, d1
	move.w 0x6(sp), d2 /* opcode is offset 0x6 */
	jsr printval_u32

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

