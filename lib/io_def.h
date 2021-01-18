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
 * Control port bits/masks
 */
#define CTRL_PC0_BIT  0
#define CTRL_PC1_BIT  1
#define CTRL_PC2_BIT  2
#define CTRL_PC3_BIT  3
#define CTRL_PC4_BIT  4
#define CTRL_PC5_BIT  5
#define CTRL_PC6_BIT  6
#define CTRL_INT_BIT  7

#define CTRL_PC0_MSK  1 << CTRL_PC0_BIT
#define CTRL_PC1_MSK  1 << CTRL_PC1_BIT
#define CTRL_PC2_MSK  1 << CTRL_PC2_BIT
#define CTRL_PC3_MSK  1 << CTRL_PC3_BIT
#define CTRL_PC4_MSK  1 << CTRL_PC4_BIT
#define CTRL_PC5_MSK  1 << CTRL_PC5_BIT
#define CTRL_PC6_MSK  1 << CTRL_PC6_BIT
#define CTRL_INT_MSK  1 << CTRL_INT_BIT

/**
 * Serial control port bits/masks
 */
#define SCTRL_TFUL_BIT  0
#define SCTRL_RRDY_BIT  1
#define SCTRL_RERR_BIT  2
#define SCTRL_RINT_BIT  3
#define SCTRL_SOUT_BIT  4
#define SCTRL_SIN_BIT   5
#define SCTRL_BPS_BIT   6

#define SCTRL_TFUL_MSK  1 << SCTRL_TFUL_BIT
#define SCTRL_RRDY_MSK  1 << SCTRL_RRDY_BIT
#define SCTRL_RERR_MSK  1 << SCTRL_RERR_BIT
#define SCTRL_RINT_MSK  1 << SCTRL_RINT_BIT
#define SCTRL_SOUT_MSK  1 << SCTRL_SOUT_BIT
#define SCTRL_SIN_MSK   1 << SCTRL_SIN_BIT
#define SCTRL_BPS_MSK   3 << SCTRL_BPS_BIT

/**
 * Input bits/masks
*/
#define PAD_UP_BIT     0
#define PAD_DOWN_BIT   1
#define PAD_LEFT_BIT   2
#define PAD_RIGHT_BIT  3
#define PAD_A_BIT      6
#define PAD_B_BIT      4
#define PAD_C_BIT      5
#define PAD_START_BIT  7

#define PAD_UP_MSK     1 << PAD_UP_BIT
#define PAD_DOWN_MSK   1 << PAD_DOWN_BIT
#define PAD_LEFT_MSK   1 << PAD_LEFT_BIT
#define PAD_RIGHT_MSK  1 << PAD_RIGHT_BIT
#define PAD_A_MSK      1 << PAD_A_BIT
#define PAD_B_MSK      1 << PAD_B_BIT
#define PAD_C_MSK      1 << PAD_C_BIT
#define PAD_START_MSK  1 << PAD_START_BIT

#endif
