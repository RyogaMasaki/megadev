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

_spur:
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