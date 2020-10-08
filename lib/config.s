/* Project Settings */

/* Initial environment settings */

/* VDP SETTINGS */
/* Default ddresses for name tables */
.equ VDP_SCROLLA_NMTBL,  0xC000
.equ VDP_WINDOW_NMTBL,   0xF000
.equ VDP_SCROLLB_NMTBL,  0xE000
.equ VDP_SPR_ATBL,      0xE000
.equ VDP_HSCROLL,				0xD000

/* IO SETTINGS */
/* External device port */
/*
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
/* External port speed */
/* Sets the transfer speed of the external device port */
/*
		3 - 300 bps
		2 - 1200 bps
		1 - 2400 bps
		0 - 4800 bps
*/
.equ EXT_BAUD, 0
