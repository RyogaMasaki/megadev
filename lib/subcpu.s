/*
-----------------------------------------------------------------------
 subcpu.s
-----------------------------------------------------------------------
 Sub CPU defines
-----------------------------------------------------------------------
*/

.ifndef SUBCPU_S
.set SUBCPU_S, 1

/*
-----------------------------------------------------------------------
 Sub CPU Memory Map
-----------------------------------------------------------------------
*/
# PRG RAM
.equ  SP_ADDR,			0x006000
.equ	PRG_BASE,			0x000000

# PRG RAM can accessed in 1M chunks by the Main CPU
.equ	PRG_RAM0,			0x000000
.equ	PRG_RAM1,			0x020000
.equ	PRG_RAM2,			0x040000
.equ	PRG_RAM3,			0x060000

# WORD RAM
.equ  SUB_2M_BASE,	0x080000      /*word RAM base in 2M bit mode*/
.equ  SUB_1M_BASE,	0x0C0000      /*word RAM base in 1M bit mode*/


/*
-----------------------------------------------------------------------
 Sub CPU Gate Array Registers
-----------------------------------------------------------------------
*/
.equ	SUB_GA_BASE,				0xFF8000
.equ  GA_RESET,						SUB_GA_BASE+0x0000	/*peripheral reset*/
.equ  GA_MEMORYMODE,			SUB_GA_BASE+0x0002	/*memory mode / write protect*/
.equ  GA_CDCMODE,					SUB_GA_BASE+0x0004	/*CDC mode / device destination*/
.equ  GA_CDCRS1,					SUB_GA_BASE+0x0006	/*CDC control register*/
.equ  GA_CDCHOSTDATA,			SUB_GA_BASE+0x0008	/*16 bit CDC data to host*/
.equ  GA_DMAADDR,					SUB_GA_BASE+0x000A	/*DMA offset into dest area*/
.equ  GA_STOPWATCH,				SUB_GA_BASE+0x000C	/*CDC/gp timer 30.72us lsb*/
.equ  GA_COMFLAGS,				SUB_GA_BASE+0x000E	/*CPU to CPU commo bit flags*/
.equ  GA_COMCMD0,					SUB_GA_BASE+0x0010	/*8 MAIN->SUB word registers*/
.equ  GA_COMCMD1,					SUB_GA_BASE+0x0012
.equ  GA_COMCMD2,					SUB_GA_BASE+0x0014
.equ  GA_COMCMD3,					SUB_GA_BASE+0x0016
.equ  GA_COMCMD4,					SUB_GA_BASE+0x0018
.equ  GA_COMCMD5,					SUB_GA_BASE+0x001A
.equ  GA_COMCMD6,					SUB_GA_BASE+0x001C
.equ  GA_COMCMD7,					SUB_GA_BASE+0x001E
.equ  GA_COMSTAT0,				SUB_GA_BASE+0x0020	/*8 SUB->MAIN word registers*/
.equ  GA_COMSTAT1,				SUB_GA_BASE+0x0022
.equ  GA_COMSTAT2,				SUB_GA_BASE+0x0024
.equ  GA_COMSTAT3,				SUB_GA_BASE+0x0026
.equ  GA_COMSTAT4,				SUB_GA_BASE+0x0028
.equ  GA_COMSTAT5,				SUB_GA_BASE+0x002A
.equ  GA_COMSTAT6,				SUB_GA_BASE+0x002C
.equ  GA_COMSTAT7,				SUB_GA_BASE+0x002E
.equ  GA_INT3TIMER,				SUB_GA_BASE+0x0030	/*timer, 30.72us lsb,  0->INT3*/
.equ  GA_INTMASK,					SUB_GA_BASE+0x0032	/*interrupt control*/
.equ  GA_CDFADER,					SUB_GA_BASE+0x0034	/*fader control / spindle speed*/
.equ  GA_CDDCONTROL,			SUB_GA_BASE+0x0036	/*CDD control*/
.equ  GA_CDDCOMM,					SUB_GA_BASE+0x0038	/*CDD communication*/
.equ  GA_FONTCOLOR,				SUB_GA_BASE+0x004C	/*source color values*/
.equ  GA_FONTBITS,				SUB_GA_BASE+0x004E	/*font data*/
.equ  GA_FONTDATA,				SUB_GA_BASE+0x0056	/*read only*/
.equ  GA_STAMPSIZE,				SUB_GA_BASE+0x0058	/*stamp size / map size / repeat*/
.equ  GA_STAMPMAPBASE,		SUB_GA_BASE+0x005A	/*stamp map base address*/
.equ  GA_IMGBUFVSIZE,			SUB_GA_BASE+0x005C	/*image buffer vert size in cells*/
.equ  GA_IMGBUFSTART,			SUB_GA_BASE+0x005E	/*start address of image buffer*/
.equ  GA_IMGBUFOFFSET,		SUB_GA_BASE+0x0060	/*pixel offset into image buffer*/
.equ  GA_IMGBUFHDOTSIZE,	SUB_GA_BASE+0x0062	/*horz pixel magnification*/
.equ  GA_IMGBUFVDOTSIZE,	SUB_GA_BASE+0x0064	/*vert pixel magnification*/
.equ  GA_TRACEVECTBASE,		SUB_GA_BASE+0x0066	/*trace vector list start address*/
.equ  GA_SUBCODEADDR,			SUB_GA_BASE+0x0068	/*subcode top address*/
.equ  GA_SUBCODEBUF,			SUB_GA_BASE+0x0100	/*64 word subcode buffer area*/
.equ  GA_SUBCODEBUFIMG,		SUB_GA_BASE+0x0180	/*image of subcode buffer area*/

/*
-----------------------------------------------------------------------
 Sub CPU Register Bit/Masks - GA_MEMORYMODE
-----------------------------------------------------------------------
*/
.equ  MEMORYMODE_RET_BIT,		0
.equ  MEMORYMODE_DMNA_BIT,	1
.equ  MEMORYMODE_MODE_BIT,	2
.equ  MEMORYMODE_PM_BIT,		3
.equ  MEMORYMODE_WP0_BIT,		8
.equ  MEMORYMODE_WP1_BIT,		9
.equ  MEMORYMODE_WP2_BIT,		10
.equ  MEMORYMODE_WP3_BIT,		11
.equ  MEMORYMODE_WP4_BIT,		12
.equ  MEMORYMODE_WP5_BIT,		13
.equ  MEMORYMODE_WP6_BIT,		14
.equ  MEMORYMODE_WP7_BIT,		15

.equ  MEMORYMODE_RET_MSK,		1 << MEMORYMODE_RET_BIT
.equ  MEMORYMODE_DMNA_MSK,	1 << MEMORYMODE_DMNA_BIT
.equ  MEMORYMODE_MODE_MSK,	1 << MEMORYMODE_MODE_BIT
.equ  MEMORYMODE_PM_MSK,		1 << MEMORYMODE_PM_BIT
.equ  MEMORYMODE_WP0_MSK,		1 << MEMORYMODE_WP0_BIT
.equ  MEMORYMODE_WP1_MSK,		1 << MEMORYMODE_WP1_BIT
.equ  MEMORYMODE_WP2_MSK,		1 << MEMORYMODE_WP2_BIT
.equ  MEMORYMODE_WP3_MSK,		1 << MEMORYMODE_WP3_BIT
.equ  MEMORYMODE_WP4_MSK,		1 << MEMORYMODE_WP4_BIT
.equ  MEMORYMODE_WP5_MSK,		1 << MEMORYMODE_WP5_BIT
.equ  MEMORYMODE_WP6_MSK,		1 << MEMORYMODE_WP6_BIT
.equ  MEMORYMODE_WP7_MSK,		1 << MEMORYMODE_WP7_BIT

/*
-----------------------------------------------------------------------
 Sub CPU Register Bit/Masks - GA_COMFLAGS
-----------------------------------------------------------------------
*/
.equ  COMFLAGS_SUBBUSY_MSK,			0x0001
.equ  COMFLAGS_SUBACK_MSK,			0x0002
.equ  COMFLAGS_SUBRAMREQ_MSK,		0x0004
.equ  COMFLAGS_SUBSYNC_MSK,			0x0008
.equ  COMFLAGS_MAINBUSY_MSK,		0x0001
.equ  COMFLAGS_MAINACK_MSK,			0x0002
.equ  COMFLAGS_MAINRAMREQ_MSK,	0x0004
.equ  COMFLAGS_MAINSYNC_MSK,		0x0008

.equ  COMFLAGS_SUBBUSY_BIT,			0
.equ  COMFLAGS_SUBACK_BIT,			1
.equ  COMFLAGS_SUBRAMREQ_BIT,		2
.equ  COMFLAGS_SUBSYNC_BIT,			3

.equ  COMFLAGS_SUBSERVR_BIT,		4

.equ  COMFLAGS_MAINBUSY_BIT,		8
.equ  COMFLAGS_MAINACK_BIT,			9
.equ  COMFLAGS_MAINRAMREQ_BIT,	10
.equ  COMFLAGS_MAINSYNC_BIT,		11

.equ  COMFLAGS_MAINSERVR_BIT,		12 

/*
-----------------------------------------------------------------------
 Sub CPU Register Bit/Masks - GA_INTMASK
-----------------------------------------------------------------------
*/
.equ	INT1_GFX_BIT,			1
.equ	INT2_MD_BIT,			2
.equ	INT3_TIMER_BIT,		3
.equ	INT4_CDD_BIT,			4
.equ	INT5_CDC_BIT,			5
.equ	INT6_SUBCODE_BIT,	6

.equ	INT1_GFX_MSK,			1 << INT1_GFX_BIT
.equ	INT2_MD_MSK,			1 << INT2_MD_BIT
.equ	INT3_TIMER_MSK,		1 << INT3_TIMER_BIT
.equ	INT4_CDD_MSK,			1 << INT4_CDD_BIT
.equ	INT5_CDC_MSK,			1 << INT5_CDC_BIT
.equ	INT6_SUBCODE_MSK,	1 << INT6_SUBCODE_BIT

/*
-----------------------------------------------------------------------
 Sub CPU Register Bit/Masks - GA_CDCMODE
-----------------------------------------------------------------------
*/
.equ  CDCMODE_CABITS,		0x000F
.equ  CDCMODE_DDBITS,		0x0700
.equ  CDCMODE_DD0_MSK,	0x0100
.equ  CDCMODE_DSR_MSK,	0x4000
.equ  CDCMODE_EDT_MSK,	0x8000
.equ  CDCMODE_MAINREAD, 0x0200
.equ  CDCMODE_SUBREAD,	0x0300
.equ  CDCMODE_PCMDMA,		0x0400
.equ  CDCMODE_PRAMDMA,	0x0500
.equ  CDCMODE_WRAMDMA,	0x0700

.equ  CDCMODE_DD0_BIT,	13
.equ  CDCMODE_DSR_BIT,	14
.equ  CDCMODE_EDT_BIT,	15

.equ  CDC_MAINREAD,			2
.equ  CDC_SUBREAD,			3
.equ  CDC_PCMDMA,				4
.equ  CDC_PRAMDMA,			5
.equ  CDC_WRAMDMA,			7


.endif
