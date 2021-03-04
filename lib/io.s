/**
 * \file io.s
 * \brief IO utilities
 */

#ifndef MEGADEV__IO_S
#define MEGADEV__IO_S

#include "macros.s"
#include "io_def.h"

/*
  External comm port
	The front controller ports and rear EXT port (only present on early model
  Mega Drives) can be put into serial mode for communication with external
	devices, e.g. with your PC as a debugging tool.
	For each of the EQU entries below, modify the number in the definition to
	change the port to be used for serial communication:
		1 - Player 1 port
		2 - Player 2 port
		3 - Rear EXT port
*/
.equ EXT_CTRL, IO_CTRL3
.equ EXT_SCTRL, IO_SCTRL3
.equ EXT_RXDATA, IO_RXDATA3
.equ EXT_TXDATA, IO_TXDATA3
/*
  External comm port speed
  Sets the transfer speed of the external device port
		3 - 300 bps
		2 - 1200 bps
		1 - 2400 bps
		0 - 4800 bps
*/
.equ EXT_BAUD, 0

.section .text

/**
 * \fn init_ext
 * \brief Initialize IO port for serial communication
 */
FUNC init_ext
	INTERRUPT_DISABLE
	Z80_DO_BUSREQ
	
	/* Set comm speed; Serial in/out mode; Enable Rx interrupt */
	move.b	#((EXT_BAUD << 6) + 0b00111000), EXT_SCTRL
	move.b #0x7f, EXT_CTRL
	
	Z80_DO_BUSRELEASE
	INTERRUPT_ENABLE
	rts

/**
 * \fn ext_rx
 * \brief Read a byte from the external port
 * \param[out] D0.b 
 */
/* TODO: How does RERR play into this? */
FUNC ext_rx
1:btst #SCTRL_RRDY_BIT, (EXT_SCTRL)	// check that we're ready to receive
	beq 1b
	move.b (EXT_RXDATA), d0
	rts

/**
 * \fn ext_tx
 * \brief Transmit a byte to the external port
 * \param[in] D0.b Byte to transmit
 */
FUNC ext_tx
2:move.b (EXT_SCTRL), d1
  btst #SCTRL_TFUL_BIT, d1 // make sure transmit queue is not full
  bne 2b
  move.b d0, EXT_TXDATA
  rts

#endif
