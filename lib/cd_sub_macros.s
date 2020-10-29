/*
-----------------------------------------------------------------------
 subcpu_macros.s
-----------------------------------------------------------------------
 Macros for Sub CPU side Word RAM control (mostly)
-----------------------------------------------------------------------
*/

.ifndef SUBMACROS_S
.set SUBMACROS_S, 1

/*
-----------------------------------------------------------------------
 CLEAR_COMM_REGS
 Clears the Sub CPU comm registers
-----------------------------------------------------------------------
*/
.macro CLEAR_COMM_REGS
	lea			GA_COMSTAT0, a0
	moveq		#0, d0
	move.b	d0, -0x11(a0)		/* lower byte of comm flags */
	move.l	d0, (a0)+
	move.l	d0, (a0)+
	move.l	d0, (a0)+
	move.l	d0, (a0)+
.endm

/*
-----------------------------------------------------------------------
 WAIT_2M
 Wait until we have 2M access
-----------------------------------------------------------------------
*/
.altmacro
.macro WAIT_2M
LOCAL loop

loop:
	btst		#MEMORYMODE_DMNA_BIT, GA_MEMORYMODE+1
	beq			loop
.endm

/*
-----------------------------------------------------------------------
 GRANT_2M
 Grants 2M Word RAM to the Main CPU and waits for the switch
-----------------------------------------------------------------------
*/
.altmacro
.macro GRANT_2M
LOCAL loop

loop:
	bset 		#MEMORYMODE_RET_BIT, GA_MEMORYMODE+1
	btst		#MEMORYMODE_RET_BIT, GA_MEMORYMODE+1
	beq			loop
.endm

.endif
