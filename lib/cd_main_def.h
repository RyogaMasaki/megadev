/**
 * \file cd_main_def.h
 * \brief Hardware memory map, Gate Array (GA) register and entry vector definitions
 * for the Main CPU side
 */

#ifndef MEGADEV__CD_MAIN_DEF_H
#define MEGADEV__CD_MAIN_DEF_H

/**
 * 2M/1M Mapping
 */
#define MAIN_2M_BASE  0x200000	/* word RAM base in 2M mode */
#define MAIN_1M_BASE  0x200000	/* word RAM base in 1M mode */
#define MAIN_1M_VRAM  0x220000	/* VDP tiles for 1M mode */

/**
 * Initial Program (IP) enntry
 */
#define _IP_ENTRY 0xff0000

/**
 * System Jump Table
 */
#define _reset    0xfffd00    /* -reset jump table */
#define _mlevel6  0xfffd06    /* -V interrupt */
#define _mlevel4  0xfffd0c    /* -H interrupt */
#define _mlevel2  0xfffd12    /* -external interrupt */
#define _mtrap00  0xfffd18    /* -TRAP #00 */
#define _mtrap01  0xfffd1e
#define _mtrap02  0xfffd24
#define _mtrap03  0xfffd2a
#define _mtrap04  0xfffd30
#define _mtrap05  0xfffd36
#define _mtrap06  0xfffd3c
#define _mtrap07  0xfffd42
#define _mtrap08  0xfffd48
#define _mtrap09  0xfffd4e
#define _mtrap10  0xfffd54
#define _mtrap11  0xfffd5a
#define _mtrap12  0xfffd60
#define _mtrap13  0xfffd66
#define _mtrap14  0xfffd6c
#define _mtrap15  0xfffd72
#define _monkerr  0xfffd78    /* -onk */
// the redundant addresses here seem to be intentional
// This frees up an extra jump slot at the end, which looks to be
// the jump table code for the Backup RAM cart
#define _madrerr  0xfffd7e    /* -address error */
#define _mcoderr  0xfffd7e    /* -undefined code */
#define _mdiverr  0xfffd84    /* -divide error */
#define _mtrperr  0xfffd8e
#define _mnocod0  0xfffd90
#define _mnocod1  0xfffd96
#define _mspverr  0xfffd9c
#define _mtrace   0xfffda2
#define _vint_ex  0xfffda8
#define mburam    0xfffdae

/**
 * \var GA_RESET
 * \brief Sub CPU Reset / Bus Request
 * \details
 * | F| E| D| C| B| A| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|
 * |IEN2| ||||||IFL2| ||||||SBRQ|SRES|
 * 
 * \param SRES Sub CPU reset
 * \details 0 = Run / 1 = Reset
 * \param SBRQ Sub CPU bus access request
 * \details W: 0 = Cancel / 1 = Request \n R: 0 = Sub CPU running / 1 = Acknowledge
 * \param IFL2 Send INT2 to Sub CPU
 * \details Write: 0 = Not used / 1 = Send INT 2 to Sub CPU \n Read: 0 = INT 2 in progress / 1 = INT 2 not occurred yet
 * \param IEN2 Mask state of INT2 on Sub CPU
 * \details 0 = Masked / 1 = Enabled
 */
#define GA_RESET        0xA12000

/**
 * \var GA_MEMORYMODE
 * \brief Word RAM Memory Mode / Sub CPU RAM Write Protect
 * \details
 * | F| E| D| C| B| A| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|
 * |WP7|WP6|WP5|WP4|WP3|WP2|WP1|WP0|BK1|BK0| |||MODE|DMNA|RET|
 * 
 * \param WP Write protect Sub CPU RAM
 * \param BK PRG-RAM bank select
 * \param MODE Word RAM layout
 * \param DMNA Main CPU will not access Word RAM
 * \param RET Give Word RAM control to Main CPU
 *
 * WP Write protect an area of Sub CPU RAM from 0 to 0x1FE00 in increments
 * of 0x200
 * BK|PRG-RAM bank select for Main CPU access
 * (4M PRG-RAM divided into 1M banks)
 * MODE|Word RAM Mode
 *     |  Read Only: 0 = 2M / 1 = 1M/1M
 * DMNA|"Declaration of Main CPU No Access" on Word RAM
 *     |  Effect depends on MODE bit:
 * 
 * 
 *       MODE = 0 (2M):
 *        Write: 0 = N/A / 1 = Return Word RAM to Sub CPU
 *        Read: 0 = Return Word RAM to Sub CPU In Progress
 *              1 = Return Word RAM to Sub CPU Completed
 *       MODE = 1 (1M/1M):
 *        Write: 0 = N/A / 1 = Request 1M bank swap
 *        Read: 0 = Bank swap In Progress
 *              1 = Bank swap Completed
 * RET|Return Word RAM to Main CPU
 *      Effect depends on MODE bit:
 *			MODE = 0 (2M):
 *			 Read Only: 0 = Return Word RAM to Main CPU In Progress
 *			            1 = Return Word RAM to Main CPU Completed
 *       MODE = 1 (1M/1M):
 *        Read Only: 0 = Word RAM Bank 0 attached to Main CPU, Bank 1 to Sub CPU
 *                   1 = Word RAM Bank 0 attached to Sub CPU, Bank 1 to Main CPU
 */
#define GA_MEMORYMODE   0xA12002

/**
 * \def GA_HINTVECT
 * \brief HINT Vector
 * \details
 * | F| E| D| C| B| A| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|
 * |HIBF|HIBE|HIBD|HIBC|HIBB|HIBA|HIB9|HIB8|HIB7|HIB6|HIB5|HIB4|HIB3|HIB2|HIB1|HIB0|
 *
 * HIB: Specifies the lower word of the HINT (Level 4) interrupt vector
 *      The upper word is specied at the standard location (0x70), the value
 *      of which is 0x00FF by the Boot ROM.
 */
#define GA_HINTVECT     0xA12006

/**
 * \def GA_CDCMODE
 * \brief CDC Mode
 * \details
 * | F| E| D| C| B| A| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|-:|
 * |EDT|DSR| |||DD2|DD1|DD0| ||||||||
 *
 * EDT: 1 = All data has been transferred from CDC
 * DSR: 1 = Data from CDC is present in GA_CDCHOSTDATA register
 * DD: Set the destination bus for the CDC data. Refer to the manual for the
 *     allowed values.
 */
#define GA_CDCMODE      0xA12004


#define GA_CDCHOSTDATA  0xA12008 	/* 16-bit CDC host data */
#define GA_STOPWATCH    0xA1200C 	/* CDC/gp timer 30.72us lsb */
#define GA_COMFLAGS     0xA1200E 	/* CPU to CPU commo bit flags */
#define GA_COMCMD0      0xA12010 	/* 8 MAIN->SUB word registers */
#define GA_COMCMD1      0xA12012
#define GA_COMCMD2      0xA12014
#define GA_COMCMD3      0xA12016
#define GA_COMCMD4      0xA12018
#define GA_COMCMD5      0xA1201A
#define GA_COMCMD6      0xA1201C
#define GA_COMCMD7      0xA1201E
#define GA_COMSTAT0     0xA12020 	/* 8 SUB->MAIN word registers */
#define GA_COMSTAT1     0xA12022
#define GA_COMSTAT2     0xA12024
#define GA_COMSTAT3     0xA12026
#define GA_COMSTAT4     0xA12028
#define GA_COMSTAT5     0xA1202A
#define GA_COMSTAT6     0xA1202C
#define GA_COMSTAT7     0xA1202E

/**
 * GA Register bits/masks
 */

// GA_RESET
#define RESET_SRES_BIT  0
#define RESET_SBRQ_BIT  1
#define RESET_IFL2_BIT  8

#define RESET_SRES_MSK  1 << RESET_SRES_BIT // Sub-CPU reset
#define RESET_SBRQ_MSK  1 << RESET_SBRQ_BIT // Sub-CPU bus request
#define RESET_IFL2_MSK  1 << RESET_IFL2_BIT // INT02 to Sub-CPU

// GA_MEMORYMODE
#define MEMORYMODE_RET_BIT   0
#define MEMORYMODE_DMNA_BIT  1
#define MEMORYMODE_MODE_BIT  2
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
#define MEMORYMODE_BK_MSK    0x00C0
#define MEMORYMODE_WP0_MSK   1 << MEMORYMODE_WP0_BIT
#define MEMORYMODE_WP1_MSK   1 << MEMORYMODE_WP1_BIT
#define MEMORYMODE_WP2_MSK   1 << MEMORYMODE_WP2_BIT
#define MEMORYMODE_WP3_MSK   1 << MEMORYMODE_WP3_BIT
#define MEMORYMODE_WP4_MSK   1 << MEMORYMODE_WP4_BIT
#define MEMORYMODE_WP5_MSK   1 << MEMORYMODE_WP5_BIT
#define MEMORYMODE_WP6_MSK   1 << MEMORYMODE_WP6_BIT
#define MEMORYMODE_WP7_MSK   1 << MEMORYMODE_WP7_BIT


/**
 * RAM locations
 */

/**
 * Top of stack
 */
#define STACK         0xfffd00




#endif
