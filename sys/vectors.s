.text
/* M68k vector table */
	.long	0xfffe00		| Stack pointer 
	.long	_sysinit		| Program start
	
	/* Standard M68k exception vectors */
	.long	_exBUS
	.long	_exADDRESS
	.long	_exILLEGAL
	.long	_exZERO
	.long	_exCHKINST
	.long	_exTRAPV
	.long	_exPRIV
	.long	_exTRACE
	.long	_exLINE1010
	.long	_exLINE1111

	/* Unused exceptions (12 entries) */
	.fill 12, 4, 0
	
	/* Spurious interrupt */
	.long	_exSPUR

	/* IRQ autovectors */
	.long	0
	.long	_EXINT	| IRQ2 - External Interrupt
	.long	0
	.long	_HINT		| IRQ4 - Horizontal Interrupt
	.long	0
	.long	_VINT		| IRQ6 - Vertical Interrupt
	.long	0

	/* Trap exceptions */
	.long	_trap0, _trap1, _trap2, _trap3
	.long	_trap4, _trap5, _trap6, _trap7
	.long	_trap8, _trap9, _trapA, _trapB
	.long	_trapC, _trapD, _trapE, _trapF

	/* Unused exceptions (16 entries) */
	.fill 16, 4, 0

