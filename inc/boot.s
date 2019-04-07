/* Sega Megadrive Startup Code 
 * Based on implementation in SGDK
 * and other sources online
 */

.org 0x00000000

/* Makes the _start symbol visible to the linker */
.global _start

.include "io_def.s"

.equ    STACK_ADDR,    0xfffe00

.text
_start:
_m68kVectorTable:
	dc.l	STACK_ADDR			/* Initial SSP */
	dc.l	_entry					/* Program start */
	
	/* Standard M68k exception vectors */
	dc.l	_exBUS
	dc.l	_exADDRESS
	dc.l	_exILLEGAL
	dc.l	_exZERO
	dc.l	_exCHKINST
	dc.l	_exTRAPV
	dc.l	_exPRIV
	dc.l	_exTRACE
	dc.l	_exLINE1010
	dc.l	_exLINE1111

	/* Unused exceptions (12 entries) */
	.fill 12, 4, 0
	/*dc.l	_ex, _ex, _ex, _ex, _ex, _ex
	dc.l	_ex, _ex, _ex, _ex, _ex, _ex*/
	
	/* Spurious interrupt */
	dc.l	_exSPUR

	/* IRQ autovectors */
	dc.l	0
	dc.l	_EXINT	| IRQ2 - External Interrupt
	dc.l	0
	dc.l	_HINT		| IRQ4 - Horizontal Interrupt
	dc.l	0
	dc.l	_VINT		| IRQ6 - Vertical Interrupt
	dc.l	0

	/* Trap exceptions */
	dc.l	_trap0, _trap1, _trap2, _trap3
	dc.l	_trap4, _trap5, _trap6, _trap7
	dc.l	_trap8, _trap9, _trapA, _trapB
	dc.l	_trapC, _trapD, _trapE, _trapF

	/* Unused exceptions (16 entries) */
		.fill 16, 4, 0
	/*dc.l	_ex, _ex, _ex, _ex, _ex, _ex
	dc.l	_ex, _ex, _ex, _ex, _ex, _ex
	dc.l	_ex, _ex, _ex, _ex*/

	/* Include the MegaDrive program header */
.include "md_head.s"


/* Error Exception implementations */
_exBUS:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "BUS ERROR"

_exADDRESS:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "ADDRESS ERROR"

_exILLEGAL:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "ILLEGAL INSTRUCTION"

_exZERO:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "ZERO DIVIDE"

_exCHKINST:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "CHK INSTRUCTION"

_exTRAPV:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "TRAPV"

_exPRIV:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "PRIVELEGE VIOLATION"

_exTRACE:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "TRACE"

_exLINE1010:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "LINE 1010 EMULATOR"

.align 2
_exLINE1111:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "LINE 1111 EMULATOR"

.align 2
_exSPUR:
	lea 1f, a0
	jmp handleException
	1: dc.b 1, 1
	.asciz "SPURIOUS"

.align 2
/* Interrupt Requests */
_EXINT:
	nop
	rte

_HINT:
	nop
	rte

_VINT:
	nop
	jmp vBlankInt

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
handleException:				
	jsr drawString32
	lockloop:
	jmp lockloop

_entry:
	move	#0x2700,%sr			/* disabled interrupts */
	
	tmssCheck:
	move.b	(IO_VERSION), %d0
	andi.b	#0x0f, %d0
	beq	clearRam	/* if version 0, skip TMSS */
	move.l	#0x53454741, IO_TMSS	/* write 'SEGA' ascii to TMSS port */


	clearRam:
	clr.l %d0
	clr.l %d6
	movea.l %d0, %a6	/* a6 = 0 */
	move	%a6, %sp	/* reset stack pointer (A7) */
	move.w	#0x3FF, %d6 /* set up the loop count in d6 */

	1:move.l	%d0, -(%a6)	/* decrease ptr till we hit 0xFFE00000 */
		dbra %d6, 1b		/* set to 0 */

	/* jump to the main function */
	jmp main

