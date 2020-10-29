/*
-----------------------------------------------------------------------
 maincpu.s
-----------------------------------------------------------------------
 Main CPU defines
-----------------------------------------------------------------------
*/

.ifndef MAINCPU_S
.set MAINCPU_S, 1

/*
-----------------------------------------------------------------------
 Main CPU Memory Map
-----------------------------------------------------------------------
*/
.global MAIN_2M_BASE
.equ MAIN_2M_BASE,	0x200000	/* word RAM base in 2M bit mode */
.global MAIN_1M_BASE
.equ MAIN_1M_BASE,	0x200000	/* word RAM base in 1M bit mode */
#.equ IP_START,			0xff0000	/* start of IP program */
.equ STACK,					0xfffd00	/* start of STACK (grows down) */

/*
 The memory above 0xfffd00 is not available for general purpose use
 (Used for system jump table)
*/
.equ		_reset,				0xfffd00    /* -reset jump table */
.equ		_mlevel6,			0xfffd06    /* -V interrupt */
.equ		_mlevel4,			0xfffd0c    /* -H interrupt */
.equ		_mlevel2,			0xfffd12    /* -external interrupt */
.equ		_mtrap00,			0xfffd18    /* -TRAP #00 */
.equ		_mtrap01,			0xfffd1e   
.equ		_mtrap02,			0xfffd24   
.equ		_mtrap03,			0xfffd2a   
.equ		_mtrap04,			0xfffd30   
.equ		_mtrap05,			0xfffd36   
.equ		_mtrap06,			0xfffd3c   
.equ		_mtrap07,			0xfffd42   
.equ		_mtrap08,			0xfffd48   
.equ		_mtrap09,			0xfffd4e   
.equ		_mtrap10,			0xfffd54   
.equ		_mtrap11,			0xfffd5a   
.equ		_mtrap12,			0xfffd60   
.equ		_mtrap13,			0xfffd66   
.equ		_mtrap14,			0xfffd6c   
.equ		_mtrap15,			0xfffd72   
.equ		_monkerr,			0xfffd78    /* -onk */
.equ		_madrerr,			0xfffd7e    /* -address error */
.equ		_mcoderr,			0xfffd7e    /* -undefined code */
.equ		_mdiverr,			0xfffd84    /* -divide error */
.equ		_mtrperr,			0xfffd8e   
.equ		_mnocod0,			0xfffd90   
.equ		_mnocod1,			0xfffd96   
.equ		_mspverr,			0xfffd9c   
.equ		_mtrace,			0xfffda2   
.equ		_vint_ex,			0xfffda8   

/*
-----------------------------------------------------------------------
 Main CPU Gate Array Registers
-----------------------------------------------------------------------
*/

.equ		MAIN_GA_BASE,		0xA12000 							/*Main CPU gate array registers base address */
.global GA_RESET
.equ		GA_RESET,			  MAIN_GA_BASE+0x0000 	/* peripheral reset */
.global GA_MEMORYMODE
.equ		GA_MEMORYMODE,	MAIN_GA_BASE+0x0002 	/* memory mode/write protect */
.equ		GA_CDCMODE,			MAIN_GA_BASE+0x0004 	/* CDC mode/device dest */
.equ		GA_HINTVECT,		MAIN_GA_BASE+0x0006 	/* H-INT address */
.equ		GA_CDCHOSTDATA,	MAIN_GA_BASE+0x0008 	/* 16-bit CDC host data */
.equ		GA_STOPWATCH,		MAIN_GA_BASE+0x000C 	/* CDC/gp timer 30.72us lsb */
.equ		GA_COMFLAGS,		MAIN_GA_BASE+0x000E 	/* CPU to CPU commo bit flags */
.global GA_COMCMD0
.equ		GA_COMCMD0,		  MAIN_GA_BASE+0x0010 	/* 8 SUB->MAIN word registers */
.global GA_COMCMD1
.equ		GA_COMCMD1,		  MAIN_GA_BASE+0x0012
.equ		GA_COMCMD2,		  MAIN_GA_BASE+0x0014
.equ		GA_COMCMD3,		  MAIN_GA_BASE+0x0016
.equ		GA_COMCMD4,		  MAIN_GA_BASE+0x0018
.equ		GA_COMCMD5,		  MAIN_GA_BASE+0x001A
.equ		GA_COMCMD6,		  MAIN_GA_BASE+0x001C
.equ		GA_COMCMD7,		  MAIN_GA_BASE+0x001E
.global GA_COMSTAT0
.equ		GA_COMSTAT0,		MAIN_GA_BASE+0x0020 	/* 8 MAIN->SUB word registers */
.global GA_COMSTAT1
.equ		GA_COMSTAT1,		MAIN_GA_BASE+0x0022
.equ		GA_COMSTAT2,		MAIN_GA_BASE+0x0024
.equ		GA_COMSTAT3,		MAIN_GA_BASE+0x0026
.equ		GA_COMSTAT4,		MAIN_GA_BASE+0x0028
.equ		GA_COMSTAT5,		MAIN_GA_BASE+0x002A
.equ		GA_COMSTAT6,		MAIN_GA_BASE+0x002C
.equ		GA_COMSTAT7,		MAIN_GA_BASE+0x002E

/*
-----------------------------------------------------------------------
 Main CPU Register Bit/Masks - GA_RESET
-----------------------------------------------------------------------
*/
.equ		RESET_SRES_MSK,			0x0001             /* Sub-CPU reset */
.equ		RESET_SBRQ_MSK,			0x0002             /* Sub-CPU bus request */
.equ		RESET_IFL2_MSK,			0x0100             /* INT02 to Sub-CPU */

.equ		RESET_SRES_BIT,			0
.equ		RESET_SBRQ_BIT,			1
.equ		RESET_IFL2_BIT,			8


/*
-----------------------------------------------------------------------
 Main CPU Register Bit/Masks - GA_MEMORYMODE
-----------------------------------------------------------------------
*/
.equ		MEMORYMODE_RET_MSK,			0x0001
.equ		MEMORYMODE_DMNA_MSK,			0x0002
.equ		MEMORYMODE_MODE_MSK,			0x0004
.equ		MEMORYMODE_BK_MSK,			0x00C0
.equ		MEMORYMODE_WP0_MSK,			0x0100
.equ		MEMORYMODE_WP1_MSK,			0x0200
.equ		MEMORYMODE_WP2_MSK,			0x0400
.equ		MEMORYMODE_WP3_MSK,			0x0800
.equ		MEMORYMODE_WP4_MSK,			0x1000
.equ		MEMORYMODE_WP5_MSK,			0x2000
.equ		MEMORYMODE_WP6_MSK,			0x4000
.equ		MEMORYMODE_WP7_MSK,			0x8000

.equ		MEMORYMODE_RET_BIT,			0
.global MEMORYMODE_DMNA_BIT
.equ		MEMORYMODE_DMNA_BIT,			1
.equ		MEMORYMODE_MODE_BIT,			2
.equ		MEMORYMODE_WP0_BIT,			8
.equ		MEMORYMODE_WP1_BIT,			9
.equ		MEMORYMODE_WP2_BIT,			10
.equ		MEMORYMODE_WP3_BIT,			11
.equ		MEMORYMODE_WP4_BIT,			12
.equ		MEMORYMODE_WP5_BIT,			13
.equ		MEMORYMODE_WP6_BIT,			14
.equ		MEMORYMODE_WP7_BIT,			15


.endif
