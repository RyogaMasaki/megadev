/**
 * \file cd_ga_main_def.h
 * Gate Array (GA) hardware definitions for the Main CPU side
 * Note that some symbol names are identical to those on the Sub CPU side
 * The GA main and sub definitions should never be compiled together for this
 * reason as there would be symbol collisions! Code for Main and Sub should
 * always be seperate targets.
 */

#ifndef MEGADEV__GA_MAIN_DEF_H
#define MEGADEV__GA_MAIN_DEF_H

#define MAIN_2M_BASE  0x200000	/* word RAM base in 2M bit mode */
#define MAIN_1M_BASE  0x200000	/* word RAM base in 1M bit mode */
#define STACK         0xfffd00	/* start of STACK (grows down) */


/*
 The memory above 0xfffd00 is not available for general purpose use
 (Used for system jump table)
*/
#define _reset				0xfffd00    /* -reset jump table */
#define _mlevel6			0xfffd06    /* -V interrupt */
#define _mlevel4			0xfffd0c    /* -H interrupt */
#define _mlevel2			0xfffd12    /* -external interrupt */
#define _mtrap00			0xfffd18    /* -TRAP #00 */
#define _mtrap01			0xfffd1e   
#define _mtrap02			0xfffd24   
#define _mtrap03			0xfffd2a   
#define _mtrap04			0xfffd30   
#define _mtrap05			0xfffd36   
#define _mtrap06			0xfffd3c   
#define _mtrap07			0xfffd42   
#define _mtrap08			0xfffd48   
#define _mtrap09			0xfffd4e   
#define _mtrap10			0xfffd54   
#define _mtrap11			0xfffd5a   
#define _mtrap12			0xfffd60   
#define _mtrap13			0xfffd66   
#define _mtrap14			0xfffd6c   
#define _mtrap15			0xfffd72   
#define _monkerr			0xfffd78    /* -onk */
#define _madrerr			0xfffd7e    /* -address error */
#define _mcoderr			0xfffd7e    /* -undefined code */
#define _mdiverr			0xfffd84    /* -divide error */
#define _mtrperr			0xfffd8e   
#define _mnocod0			0xfffd90   
#define _mnocod1			0xfffd96   
#define _mspverr			0xfffd9c   
#define _mtrace			0xfffda2   
#define _vint_ex			0xfffda8   


/*
-----------------------------------------------------------------------
 Main CPU Gate Array Registers
-----------------------------------------------------------------------
*/

//#define MAIN_GA_BASE    0xA12000 							/*Main CPU gate array registers base address */
#define GA_RESET        0xA12000 	/* peripheral reset */
#define GA_MEMORYMODE   0xA12002 	/* memory mode/write protect */
#define GA_CDCMODE      0xA12004 	/* CDC mode/device dest */
#define GA_HINTVECT     0xA12006 	/* H-INT address */
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

/*
-----------------------------------------------------------------------
 Main CPU Register Bit/Masks - GA_RESET
-----------------------------------------------------------------------
*/
#define RESET_SRES_MSK			0x0001             /* Sub-CPU reset */
#define RESET_SBRQ_MSK			0x0002             /* Sub-CPU bus request */
#define RESET_IFL2_MSK			0x0100             /* INT02 to Sub-CPU */

#define RESET_SRES_BIT			0
#define RESET_SBRQ_BIT			1
#define RESET_IFL2_BIT			8


/*
-----------------------------------------------------------------------
 Main CPU Register Bit/Masks - GA_MEMORYMODE
-----------------------------------------------------------------------
*/
#define MEMORYMODE_RET_MSK			0x0001
#define MEMORYMODE_DMNA_MSK			0x0002
#define MEMORYMODE_MODE_MSK			0x0004
#define MEMORYMODE_BK_MSK			0x00C0
#define MEMORYMODE_WP0_MSK			0x0100
#define MEMORYMODE_WP1_MSK			0x0200
#define MEMORYMODE_WP2_MSK			0x0400
#define MEMORYMODE_WP3_MSK			0x0800
#define MEMORYMODE_WP4_MSK			0x1000
#define MEMORYMODE_WP5_MSK			0x2000
#define MEMORYMODE_WP6_MSK			0x4000
#define MEMORYMODE_WP7_MSK			0x8000

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

#endif
