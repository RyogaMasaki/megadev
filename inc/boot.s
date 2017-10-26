/* Sega Megadrive Startup Code 
 * Based on implementation in SGDK
 * and other sources online
 */

.org 0x00000000

.include "io_def.s"
.include "vdp_def.s"

.equ    STACK_ADDR,    0x00fffe00

__START:
_m68kVectorTable:
	dc.l	STACK_ADDR			/* Initial SSP */
	dc.l	_entry				/* Program start */
	
	/* Standard M68k exception vectors */
	dc.l	_errBus
	dc.l	_errAddr
	dc.l	_errIllegal
	dc.l	_errZero
	dc.l	_errChkInst
	dc.l	_errTrapV
	dc.l	_errPriv
	dc.l	_errTrace
	dc.l	_errLine1010
	dc.l	_errLine1111

	/* Unused exceptions (12 entries) */
	dc.l	_ex, _ex, _ex, _ex, _ex, _ex
	dc.l	_ex, _ex, _ex, _ex, _ex, _ex

	/* Interrupt Requests (IRQ) */
	dc.l	_irq1
	dc.l	_extInt			/* IRQ2 - External Interrupt */
	dc.l	_irq3
	dc.l	_hBlankInt		/* IRQ4 - Horizontal Blank */
	dc.l	_irq5
	dc.l	_vBlankInt		/* IRQ6 - Vertical Blank */
	dc.l	_irq7

	/* Trap exceptions */
	dc.l	_trap0, _trap1, _trap2, _trap3
	dc.l	_trap4, _trap5, _trap6, _trap7
	dc.l	_trap8, _trap9, _trapA, _trapB
	dc.l	_trapC, _trapD, _trapE, _trapF

	/* Unused exceptions (16 entries) */
	dc.l	_ex, _ex, _ex, _ex, _ex, _ex
	dc.l	_ex, _ex, _ex, _ex, _ex, _ex
	dc.l	_ex, _ex, _ex, _ex

/* Standard M68k exceptions */
_errBus:			/* Bus error */
	jmp _ex

_errAddr:			/* Address error */
	jmp _ex

_errIllegal:		/* Illegal instruction */
	jmp _ex

_errZero:			/* Divide by zero */
	jmp _ex

_errChkInst:		/* CHK instruction */
	jmp _ex

_errTrapV:			/* TRAPV instruction */
	jmp _ex

_errPriv:			/* Privilege violation */
	jmp _ex

_errTrace:			/* Trace */
	jmp _ex

_errLine1010:		/* Line 1010 emulator */
	jmp _ex

_errLine1111:		/* Line 1111 emulator */
	jmp _ex

/* Interrupt Requests */
_irq1:				/* Unused */
	jmp _ex

_extInt:			/* External interrupt */
	rte

_irq3:				/* Unused */
	jmp _ex

_hBlankInt:			/* Horizontal Blank interrupt */
	rte

_irq5:				/* Unused */
	jmp _ex

_vBlankInt:			/* Vertical Blank interrupt */
	rte

_irq7:				/* Unused */
	jmp _ex

/* TRAP */

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

_ex:				/* Generic exception handler */

	jmp _ex

ProgHeader:
	.include "md_head.s"

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

	1:	move.l	%d0, -(%a6)	/* decrease ptr till we hit 0xFFE00000 */
		dbra %d6, 1b		/* set to 0 */

	/* --- Jump to main --- */
	move    #0x2300, %sr			/* re-enable interrupts */
	jmp __MAIN	
