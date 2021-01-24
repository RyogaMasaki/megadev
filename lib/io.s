/**
 * \file io.s
 * I/O 
 */

#ifndef MEGADEV__IO_S
#define MEGADEV__IO_S

#include "macros.s"
#include "io_def.h"
#include "config.h"

.section .text

/*
	init_ext
	Sets up port 

	INPUT:
		None
	OUTPUT:
		d0 - byte value read from external device
*/
FUNC init_ext
	INTERRUPT_DISABLE
	move.w	#0x100, Z80_BUSREQ	/* stop Z80  */
1:btst	#0, Z80_BUSREQ				/* wait for stop */
	bne.s	1b
	
	/* Set comm speed; Serial in/out mode; Enable Rx interrupt */
	move.b	#((EXT_BAUD << 6) + 0b00111000), EXT_SCTRL
	move.b #0x7f, EXT_CTRL
	move.w	#0, Z80_BUSREQ	/* Restart the Z80 */
	INTERRUPT_ENABLE
	rts


/*
	ext_rx
	Reads a byte from the external device

	INPUT:
		None
	OUTPUT:
		d0 - byte value received
*/
/* TODO: How does RERR play into this? */
FUNC ext_rx
	#movem.l d0-d7/a0-a6,-(sp)
1:btst #1, (EXT_SCTRL)		/* check bit 1 (Rxd READY) first */
	beq 1b
	
	moveq #0, d0 
	move.b (EXT_RXDATA), d0

	#movem.l (sp)+, d0-d7/a0-a6
	rts

/*
	ext_tx
	Transmits a byte to the external device

	INPUT:
		None
	OUTPUT:
		d0 - byte value to transmit
*/
FUNC ext_tx
#	movem.l d1, -(sp)
1:btst #0, (EXT_SCTRL)		/* check bit 1 (Rxd READY) first */
	bne 1b
#2:move.b (EXT_SCTRL), d1
#	btst #0, d1
#	bne 2b
	move.b d0, EXT_TXDATA
#	movem.l (sp)+, d1
	rts

#endif
