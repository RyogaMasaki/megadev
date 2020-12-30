/**
 * \file cd_bios_def.h
 * Mega CD BIOS call definitions for asm and C sources
 * BIOS calls are made by the Sub CPU
 */

#ifndef MEGADEV__CD_BIOS_DEF_H
#define MEGADEV__CD_BIOS_DEF_H

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
#define _BURAM			0x00005F16
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

/*
	Backup RAM (BRAM) bios call codes
*/
#define BRMINIT    0x0000
#define BRMSTAT    0x0001
#define BRMSERCH   0x0002
#define BRMREAD    0x0003
#define BRMWRITE   0x0004
#define BRMDEL     0x0005
#define BRMFORMAT  0x0006
#define BRMDIR     0x0007
#define BRMVERIFY  0x0008

#endif
