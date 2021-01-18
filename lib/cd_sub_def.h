/**
 * \file cd_sub_def.h
 * Gate Array (GA) and BIOS function entry definitions
 * for the Sub CPU side
 */

#ifndef MEGADEV__CD_SUB_DEF_H
#define MEGADEV__CD_SUB_DEF_H

//# PRG RAM
#define  SP_ADDR   0x006000
#define  PRG_BASE  0x000000

//# PRG RAM can accessed in 1M chunks by the Main CPU
#define PRG_RAM0  0x000000
#define PRG_RAM1  0x020000
#define PRG_RAM2  0x040000
#define PRG_RAM3  0x060000

//# WORD RAM
#define SUB_2M_BASE  0x080000      /*word RAM base in 2M bit mode*/
#define SUB_1M_BASE  0x0C0000      /*word RAM base in 1M bit mode*/

/*
-----------------------------------------------------------------------
 Sub CPU Gate Array Registers
-----------------------------------------------------------------------
*/
#define GA_RESET           0xFF8000  /*peripheral reset*/
#define GA_MEMORYMODE      0xFF8002  /*memory mode / write protect*/
#define GA_CDCMODE         0xFF8004	/*CDC mode / device destination*/
#define GA_CDCRS1          0xFF8006	/*CDC control register*/
#define GA_CDCHOSTDATA     0xFF8008	/*16 bit CDC data to host*/
#define GA_DMAADDR         0xFF800A	/*DMA offset into dest area*/
#define GA_STOPWATCH       0xFF800C	/*CDC/gp timer 30.72us lsb*/
#define GA_COMFLAGS        0xFF800E	/*CPU to CPU commo bit flags*/
#define GA_COMCMD0         0xFF8010	/*8 MAIN->SUB word registers*/
#define GA_COMCMD1         0xFF8012
#define GA_COMCMD2         0xFF8014
#define GA_COMCMD3         0xFF8016
#define GA_COMCMD4         0xFF8018
#define GA_COMCMD5         0xFF801A
#define GA_COMCMD6         0xFF801C
#define GA_COMCMD7         0xFF801E
#define GA_COMSTAT0        0xFF8020	/*8 SUB->MAIN word registers*/
#define GA_COMSTAT1        0xFF8022
#define GA_COMSTAT2        0xFF8024
#define GA_COMSTAT3        0xFF8026
#define GA_COMSTAT4        0xFF8028
#define GA_COMSTAT5        0xFF802A
#define GA_COMSTAT6        0xFF802C
#define GA_COMSTAT7        0xFF802E
#define GA_INT3TIMER       0xFF8030	/*timer 30.72us lsb  0->INT3*/
#define GA_INTMASK         0xFF8032	/*interrupt control*/
#define GA_CDFADER         0xFF8034	/*fader control / spindle speed*/
#define GA_CDDCONTROL      0xFF8036	/*CDD control*/
#define GA_CDDCOMM         0xFF8038	/*CDD communication*/
#define GA_FONTCOLOR       0xFF804C	/*source color values*/
#define GA_FONTBITS        0xFF804E	/*font data (1bpp)*/
#define GA_FONTDATA        0xFF8050	/* font data (VRAM format) - 8 bytes*/
#define GA_STAMPSIZE       0xFF8058	/*stamp size / map size / repeat*/
#define GA_STAMPMAPBASE    0xFF805A	/*stamp map base address*/
#define GA_IMGBUFVSIZE     0xFF805C	/*image buffer vert size in cells*/
#define GA_IMGBUFSTART     0xFF805E	/*start address of image buffer*/
#define GA_IMGBUFOFFSET    0xFF8060	/*pixel offset into image buffer*/
#define GA_IMGBUFHDOTSIZE  0xFF8062	/*horz pixel magnification*/
#define GA_IMGBUFVDOTSIZE  0xFF8064	/*vert pixel magnification*/
#define GA_TRACEVECTBASE   0xFF8066	/*trace vector list start address*/
#define GA_SUBCODEADDR     0xFF8068	/*subcode top address*/
#define GA_SUBCODEBUF      0xFF8100	/*64 word subcode buffer area*/
#define GA_SUBCODEBUFIMG   0xFF8180	/*image of subcode buffer area*/

/*
-----------------------------------------------------------------------
 Sub CPU Register Bit/Masks - GA_MEMORYMODE
-----------------------------------------------------------------------
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

/*
-----------------------------------------------------------------------
 Sub CPU Register Bit/Masks - GA_COMFLAGS
 Note that the bits are not actually defined in the official Mega CD
 documentation. However, they are defined as such below in (as far as I can
 tell) official code examples for 32X/CD development. You are free to ignore
 the semantics attached to each bit and used them as you wish.
-----------------------------------------------------------------------
*/

// applied to GA_COMFLAGS
#define COMFLAGS_MAINBUSY_MSK    0x0001
#define COMFLAGS_MAINACK_MSK     0x0002
#define COMFLAGS_MAINRAMREQ_MSK  0x0004
#define COMFLAGS_MAINSYNC_MSK    0x0008

// applied to GA_COMFLAGS+1
#define COMFLAGS_SUBBUSY_MSK     0x0001
#define COMFLAGS_SUBACK_MSK      0x0002
#define COMFLAGS_SUBRAMREQ_MSK   0x0004
#define COMFLAGS_SUBSYNC_MSK     0x0008

#define COMFLAGS_SUBBUSY_BIT    0
#define COMFLAGS_SUBACK_BIT     1
#define COMFLAGS_SUBRAMREQ_BIT  2
#define COMFLAGS_SUBSYNC_BIT    3

#define COMFLAGS_SUBSERVR_BIT   4

#define COMFLAGS_MAINBUSY_BIT   8
#define COMFLAGS_MAINACK_BIT    9
#define COMFLAGS_MAINRAMREQ_BIT 10
#define COMFLAGS_MAINSYNC_BIT   11

#define COMFLAGS_MAINSERVR_BIT  12 

/*
-----------------------------------------------------------------------
 Sub CPU Register Bit/Masks - GA_INTMASK
-----------------------------------------------------------------------
*/
#define INT1_GFX_BIT			1
#define INT2_MD_BIT			2
#define INT3_TIMER_BIT		3
#define INT4_CDD_BIT			4
#define INT5_CDC_BIT			5
#define INT6_SUBCODE_BIT	6

#define INT1_GFX_MSK			1 << INT1_GFX_BIT
#define INT2_MD_MSK			1 << INT2_MD_BIT
#define INT3_TIMER_MSK		1 << INT3_TIMER_BIT
#define INT4_CDD_MSK			1 << INT4_CDD_BIT
#define INT5_CDC_MSK			1 << INT5_CDC_BIT
#define INT6_SUBCODE_MSK	1 << INT6_SUBCODE_BIT

/*
-----------------------------------------------------------------------
 Sub CPU Register Bit/Masks - GA_CDCMODE
-----------------------------------------------------------------------
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


/**
 * -----------------------------------------------------------------------------
 * BIOS FUNCTION CODES
 * -----------------------------------------------------------------------------
 */
#define MSCSTOP				0x0002
#define MSCPAUSEON			0x0003
#define MSCPAUSEOFF		0x0004
#define MSCSCANFF			0x0005
#define MSCSCANFR			0x0006
#define MSCSCANOFF			0x0007
#define ROMPAUSEON			0x0008
#define ROMPAUSEOFF		0x0009
#define DRVOPEN				0x000A
#define DRVINIT				0x0010
#define MSCPLAY				0x0011
#define MSCPLAY1				0x0012
#define MSCPLAYR				0x0013
#define MSCPLAYT				0x0014
#define MSCSEEK				0x0015
#define MSCSEEKT				0x0016
#define ROMREAD				0x0017
#define ROMSEEK				0x0018
#define MSCSEEK1				0x0019
#define TESTENTRY			0x001E
#define TESTENTRYLOOP	0x001F
#define ROMREADN				0x0020
#define ROMREADE				0x0021
#define CDBCHK					0x0080
#define CDBSTAT				0x0081
#define CDBTOCWRITE		0x0082
#define CDBTOCREAD			0x0083
#define CDBPAUSE				0x0084
#define FDRSET					0x0085
#define FDRCHG					0x0086
#define CDCSTART				0x0087
#define CDCSTARTP			0x0088
#define CDCSTOP				0x0089
#define CDCSTAT				0x008A
#define CDCREAD				0x008B
#define CDCTRN					0x008C
#define CDCACK					0x008D
#define SCDINIT				0x008E
#define SCDSTART				0x008F
#define SCDSTOP				0x0090
#define SCDSTAT				0x0091
#define SCDREAD				0x0092
#define SCDPQ					0x0093
#define SCDPQL					0x0094
#define LEDSET					0x0095
#define CDCSETMODE			0x0096
#define WONDERREQ			0x0097
#define WONDERCHK			0x0098
#define CBTINIT				0x0000
#define CBTINT					0x0001
#define CBTOPENDISC		0x0002
#define CBTOPENSTAT		0x0003
#define CBTCHKDISC			0x0004
#define CBTCHKSTAT			0x0005
#define CBTIPDISC			0x0006
#define CBTIPSTAT			0x0007
#define CBTSPDISC			0x0008
#define CBTSPSTAT			0x0009

/**
 * -----------------------------------------------------------------------------
 * BIOS ENTRY POINTS
 * -----------------------------------------------------------------------------
 */
#define _ADRERR		0x00005F40
#define _BOOTSTAT	0x00005EA0

#define _CDBIOS		0x00005F22
#define _CDBOOT		0x00005F1C
#define _CDSTAT		0x00005E80
#define _CHKERR		0x00005F52
#define _CODERR		0x00005F46
#define _DEVERR		0x00005F4C
#define _LEVEL1		0x00005F76
#define _LEVEL2		0x00005F7C
#define _LEVEL3		0x00005F82 /*TIMER INTERRUPT*/
#define _LEVEL4		0x00005F88
#define _LEVEL5		0x00005F8E
#define _LEVEL6		0x00005F94
#define _LEVEL7		0x00005F9A
#define _NOCOD0		0x00005F6A
#define _NOCOD1		0x00005F70
#define _SETJMPTBL	0x00005F0A
#define _SPVERR		0x00005F5E
#define _TRACE			0x00005F64
#define _TRAP00		0x00005FA0
#define _TRAP01		0x00005FA6
#define _TRAP02		0x00005FAC
#define _TRAP03		0x00005FB2
#define _TRAP04		0x00005FB8
#define _TRAP05		0x00005FBE
#define _TRAP06		0x00005FC4
#define _TRAP07		0x00005FCA
#define _TRAP08		0x00005FD0
#define _TRAP09		0x00005FD6
#define _TRAP10		0x00005FDC
#define _TRAP11		0x00005FE2
#define _TRAP12		0x00005FE8
#define _TRAP13		0x00005FEE
#define _TRAP14		0x00005FF4
#define _TRAP15		0x00005FFA
#define _TRPERR		0x00005F58
#define _USERCALL0	0x00005F28 /* SP Init */
#define _USERCALL1	0x00005F2E /* SP Main */
#define _USERCALL2	0x00005F34 /* SP INT2 */
#define _USERCALL3	0x00005F3A /* SP User Interrupt */
#define _USERMODE	0x00005EA6
#define _WAITVSYNC	0x00005F10


#endif
