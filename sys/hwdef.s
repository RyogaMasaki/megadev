/* Hardware definitions */

/* Version register */
.equ    VERSION,	  0xA10001  | 16/32 bit r

/* IO Ports */
.equ    IO_DATA1,		0xA10003
.equ    IO_DATA2,		0xA10005
.equ    IO_DATA3,		0xA10007
.equ    IO_CTRL1,		0xA10009
.equ    IO_CTRL2,		0xA1000B
.equ    IO_CTRL3,		0xA1000D
.equ    IO_TXDATA1,	0xA1000F
.equ    IO_RXDATA1,	0xA10011
.equ    IO_SCTRL1,	0xA10013
.equ    IO_TXDATA2,	0xA10015
.equ    IO_RXDATA2,	0xA10017
.equ    IO_SCTRL2,	0xA10019
.equ    IO_TXDATA3,	0xA1001B
.equ    IO_RXDATA3,	0xA1001D
.equ    IO_SCTRL3,	0xA1001F

/* Z80 Control */
.equ    Z80_ADDR,   0xA00000
.equ		Z80_BUSREQ, 0xA11100
.equ		Z80_RESET,	0xA11200

/* TMSS Register */
.equ		IO_TMSS,		0xA14000

/* VDP Ports & Registers */
.equ	VDP_DATA,			0xC00000  | 16 bit r/w
.equ	VDP_CTRL,			0xC00004  | 16 bit r/w
.equ	VDP_HVCOUNT,  0xC00008  | 16 bit r
.equ	VDP_DEBUG,    0xC0001C

