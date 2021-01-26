/**
 * \file cd_sub_def.h
 * Hardware and Gate Array definitions
 * (Intended for Sub CPU usage only)
 */

#ifndef MEGADEV__CD_SUB_DEF_H
#define MEGADEV__CD_SUB_DEF_H

/**
 * Program RAM (PRG RAM)
 */
#define PRG_RAM   0x000000

/**
 * The Sub side program (SP) begins at 0x6000
 * Memory before this point is used by BIOS and should not be written
 * by the user
 */
#define  SP_BASE  0x006000

/**
 * PRG RAM can be accessed in 1M banks by the Main CPU
 * This provides quick access to each bank
 */
#define PRG_RAM0  0x000000
#define PRG_RAM1  0x020000
#define PRG_RAM2  0x040000
#define PRG_RAM3  0x060000

/**
 * Word RAM (2M)
 */
#define SUB_2M_BASE  0x080000      /*word RAM base in 2M bit mode*/
#define SUB_1M_BASE  0x0C0000      /*word RAM base in 1M bit mode*/


/**
 * Gate Array registers
 */
#define GA_RESET           0xFF8000
#define GA_MEMORYMODE      0xFF8002
#define GA_CDCMODE         0xFF8004
#define GA_CDCRS1          0xFF8006
#define GA_CDCHOSTDATA     0xFF8008
#define GA_DMAADDR         0xFF800A
#define GA_STOPWATCH       0xFF800C
#define GA_COMFLAGS        0xFF800E
#define GA_COMCMD0         0xFF8010
#define GA_COMCMD1         0xFF8012
#define GA_COMCMD2         0xFF8014
#define GA_COMCMD3         0xFF8016
#define GA_COMCMD4         0xFF8018
#define GA_COMCMD5         0xFF801A
#define GA_COMCMD6         0xFF801C
#define GA_COMCMD7         0xFF801E
#define GA_COMSTAT0        0xFF8020
#define GA_COMSTAT1        0xFF8022
#define GA_COMSTAT2        0xFF8024
#define GA_COMSTAT3        0xFF8026
#define GA_COMSTAT4        0xFF8028
#define GA_COMSTAT5        0xFF802A
#define GA_COMSTAT6        0xFF802C
#define GA_COMSTAT7        0xFF802E
#define GA_INT3TIMER       0xFF8030
#define GA_INTMASK         0xFF8032
#define GA_CDFADER         0xFF8034
#define GA_CDDCONTROL      0xFF8036
#define GA_CDDCOMM         0xFF8038
#define GA_FONTCOLOR       0xFF804C
#define GA_FONTBITS        0xFF804E
#define GA_FONTDATA        0xFF8050
#define GA_STAMPSIZE       0xFF8058
#define GA_STAMPMAPBASE    0xFF805A
#define GA_IMGBUFVSIZE     0xFF805C
#define GA_IMGBUFSTART     0xFF805E
#define GA_IMGBUFOFFSET    0xFF8060
#define GA_IMGBUFHDOTSIZE  0xFF8062
#define GA_IMGBUFVDOTSIZE  0xFF8064
#define GA_TRACEVECTBASE   0xFF8066
#define GA_SUBCODEADDR     0xFF8068
#define GA_SUBCODEBUF      0xFF8100
#define GA_SUBCODEBUFIMG   0xFF8180

/**
 * GA_MEMORYMODE bit/mask settings
 */
#define MEMORYMODE_RET_BIT   0
#define MEMORYMODE_DMNA_BIT  1
#define MEMORYMODE_MODE_BIT  2
#define MEMORYMODE_PM_BIT    3
#define MEMORYMODE_WP0_BIT   8
#define MEMORYMODE_WP1_BIT   9
#define MEMORYMODE_WP2_BIT   10
#define MEMORYMODE_WP3_BIT   11
#define MEMORYMODE_WP4_BIT   12
#define MEMORYMODE_WP5_BIT   13
#define MEMORYMODE_WP6_BIT   14
#define MEMORYMODE_WP7_BIT   15

#define MEMORYMODE_RET_MSK   1 << MEMORYMODE_RET_BIT
#define MEMORYMODE_DMNA_MSK  1 << MEMORYMODE_DMNA_BIT
#define MEMORYMODE_MODE_MSK  1 << MEMORYMODE_MODE_BIT
#define MEMORYMODE_PM_MSK    1 << MEMORYMODE_PM_BIT
#define MEMORYMODE_WP0_MSK   1 << MEMORYMODE_WP0_BIT
#define MEMORYMODE_WP1_MSK   1 << MEMORYMODE_WP1_BIT
#define MEMORYMODE_WP2_MSK   1 << MEMORYMODE_WP2_BIT
#define MEMORYMODE_WP3_MSK   1 << MEMORYMODE_WP3_BIT
#define MEMORYMODE_WP4_MSK   1 << MEMORYMODE_WP4_BIT
#define MEMORYMODE_WP5_MSK   1 << MEMORYMODE_WP5_BIT
#define MEMORYMODE_WP6_MSK   1 << MEMORYMODE_WP6_BIT
#define MEMORYMODE_WP7_MSK   1 << MEMORYMODE_WP7_BIT

/**
 * GA_INTMASK bit/mask settings
 */
#define INT1_GFX_BIT      1
#define INT2_MD_BIT       2
#define INT3_TIMER_BIT    3
#define INT4_CDD_BIT      4
#define INT5_CDC_BIT      5
#define INT6_SUBCODE_BIT  6

#define INT1_GFX_MSK      1 << INT1_GFX_BIT
#define INT2_MD_MSK       1 << INT2_MD_BIT
#define INT3_TIMER_MSK    1 << INT3_TIMER_BIT
#define INT4_CDD_MSK      1 << INT4_CDD_BIT
#define INT5_CDC_MSK      1 << INT5_CDC_BIT
#define INT6_SUBCODE_MSK  1 << INT6_SUBCODE_BIT

/**
 * GA_CDCMODE bit/mask settings
 */
#define CDCMODE_CABITS    0x000F
#define CDCMODE_DDBITS    0x0700
#define CDCMODE_DD0_MSK   0x0100
#define CDCMODE_DSR_MSK   0x4000
#define CDCMODE_EDT_MSK   0x8000
#define CDCMODE_MAINREAD  0x0200
#define CDCMODE_SUBREAD   0x0300
#define CDCMODE_PCMDMA    0x0400
#define CDCMODE_PRAMDMA   0x0500
#define CDCMODE_WRAMDMA   0x0700

#define CDCMODE_DD0_BIT   13
#define CDCMODE_DSR_BIT   14
#define CDCMODE_EDT_BIT   15

#define CDC_MAINREAD  2
#define CDC_SUBREAD   3
#define CDC_PCMDMA    4
#define CDC_PRAMDMA   5
#define CDC_WRAMDMA   7

#endif
