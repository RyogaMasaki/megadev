/**
 * \file io_def.h
 * I/O hardware definitions for both C and asm sources
 */

#ifndef MEGADEV__IO_DEF_H
#define MEGADEV__IO_DEF_H

/* IO Ports */
#define IO_DATA1    0xA10003
#define IO_DATA2    0xA10005
#define IO_DATA3    0xA10007
#define IO_CTRL1    0xA10009
#define IO_CTRL2    0xA1000B
#define IO_CTRL3    0xA1000D
#define IO_TXDATA1  0xA1000F
#define IO_RXDATA1  0xA10011
#define IO_SCTRL1   0xA10013
#define IO_TXDATA2  0xA10015
#define IO_RXDATA2  0xA10017
#define IO_SCTRL2   0xA10019
#define IO_TXDATA3  0xA1001B
#define IO_RXDATA3  0xA1001D
#define IO_SCTRL3   0xA1001F

/**
 * Input bitmasks
 */
#define IN_UP     0b00000001
#define IN_DOWN   0b00000010
#define IN_LEFT   0b00000100
#define IN_RIGHT  0b00001000
#define IN_A      0b01000000
#define IN_B      0b00010000
#define IN_C      0b00100000
#define IN_START  0b10000000

#endif
