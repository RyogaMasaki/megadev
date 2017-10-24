; Sega Megadrive Startup Code
; Based on implementation in SGDK
; and other sources online

	.org 0x00000000

_m68kVectorTable:
	dc.l	0x00fffe00			/* Stack address */
	dc.l	_entryPoint			/* Program start */
	
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
	dc.l	_irq1, _irq2, _irq3
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

ProgHeader:
	/* Program metadata */
	dc.b	"SEGA MEGA DRIVE "	/* Hardware name (16 bytes) */
	dc.b	"(C)SEGA 1992.SEP"	/* Copyright holder & release date (16 bytes) */
	dc.b	"YOUR GAME NAME                                  "	/* Domestic name of program/game (48 bytes) */
	dc.b	"YOUR GAME NAME                                  "	/* Intl name of program/game (48 bytes) */
	


_entryPoint:
	/* Begin hardware init */
	move	#0x2700,%sr
	
