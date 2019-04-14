.text
/* M68k vector table */
	dc.l	0xfffe00		| Stack pointer 
	dc.l	_sysinit		| Program start
	
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

