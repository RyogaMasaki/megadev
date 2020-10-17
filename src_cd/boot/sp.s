/*
-----------------------------------------------------------------------
 sp.s
 System Program (Sub CPU)
-----------------------------------------------------------------------
 Contains basic CD-ROM access utilities
-----------------------------------------------------------------------
*/
.include "cdbios.s"
.include "subcpu.s"
.include "subcpu_macros.s"

.section .text
_sp_stext:

/*
	See the BIOS Manual chapater 4 for more details about the
	header and the jump table
*/
_sp_header:
.asciz	"MAIN       "
.word		0x0100			/*version*/
.word		0						/*type*/
.long		0						/*ptr to next module*/
.long		_sp_etext-_sp_stext				/*module size - size of text section*/
.long		_sp_jumptable-_sp_stext		/*start address - address of jump table*/
.long		_sp_bend-_sp_dstart				/*work ram size - size of data + bss*/

_sp_jumptable:
.word		sp_init-_sp_jumptable
.word		sp_main-_sp_jumptable
/*this is where we specify the CD-ROM Access interrupt handler
for INT2*/
.word		cdrom_access_irq-_sp_jumptable
.word		sp_userdefined-_sp_jumptable
.word		0

.include "cdrom.s"
.section .text	/*return to text section after cdrom include */

/*
-----------------------------------------------------------------------
 SP Init
 Called once by the Boot ROM; interrupt processing not yet enabled.
 Initialize CD drive, clear comm regs, setup CDROM access loop...
-----------------------------------------------------------------------
*/
sp_init:
	CLEAR_COMM_REGS
	lea			drvinit_tracklist, a0		/* setup the BIOS DRVINIT call */
	BIOS_DRVINIT
0:BIOS_CDBSTAT						
	andi.b	#0xf0, (_CDSTAT).w		/* loop until done reading TOC */
	bne			0b
	# Set 2M mode, assert control of Word RAM
	andi.w	#~(MEMORYMODE_RET_MSK | MEMORYMODE_MODE_MSK), GA_MEMORYMODE
	CDACC_INIT				/* kickstart the access loop before IRQs start */
	rts

drvinit_tracklist:
	.byte 1, 0xff

/*
-----------------------------------------------------------------------
 SP Main
 Called by the Boot ROM after SP Init; IRQ processing has begun
 Contains the command loop
-----------------------------------------------------------------------
*/
sp_main:
	CDACC_LOAD_DIR				/*load root directory*/
0:jsr			_WAITVSYNC
	CDACC_CHECK_STATUS		/*wait till the CDROM access is done */
	bcs			0b
	cmpi.w	#ACCRES_OK, d0
	bne			sp_fatal			/* failed to load directory, crash & burn */
	# repoint stack to the end of the first bank of PRG-RAM so we have 
	# some room to work
	lea			PRG_RAM1, sp
	bclr		#INT3_TIMER_BIT, GA_INTMASK+1
	# this is where we would load our full SP (SPX), but since this is
	# just a demo, we have a small built in command loop
	jra			command_loop
	
command_loop:
	move.w	GA_COMCMD0, d0
	beq			command_loop
	cmp.w		GA_COMCMD0, d0
	bne			command_loop
	move.w	d0, d1
	add.w		d0, d0
	move.w	sub_commands(pc,d0.w), d0
	jsr			sub_commands(pc,d0.w)
	bclr		#INT1_GFX_BIT, GA_INTMASK+1
	jra			command_loop

sub_commands:
	.word		cmd00_null - sub_commands
	.word		cmd01_load_mmd - sub_commands
	.word		cmd02_play_track02 - sub_commands

/*
	no command zero due to how the CPUs keep in sync
*/
cmd00_null:
	rts

/*
	load our MMD from the disc
*/
cmd01_load_mmd:
	lea			mmd_filename, a0
	WAIT_2M
	lea			SUB_2M_BASE, a1
	jbsr		load_file
	GRANT_2M
	bra		command_complete_sync

/*
	play track 2 (CD-DA)
*/
cmd02_play_track02:
	move.w	#0x250, d1
	BIOS_FDRSET
	move.w	#0x8400, d1
	BIOS_FDRSET
	lea			cd_track, a0
	BIOS_MSCPLAYR
	bra			command_complete_sync
cd_track:
	.word 2

/*
	inform the Main CPU that we're done with its request and wait
	for an ack
*/
command_complete_sync:
	move.w	GA_COMCMD0, GA_COMSTAT0
1:move.w	GA_COMCMD0, d0
	bne			1b
	move.w	GA_COMCMD0, d0
	bne			1b
	move.w	#0, GA_COMSTAT0
	rts

/*
	something blew up
*/
sp_fatal:
	# make both LEDs blink (which is normally disallowed but Sega QA isn't
	# here to boss us around)
	moveq		#LEDERROR, d1
	BIOS_LEDSET
0:nop
	nop
	bra 0b

/*
	we're not using this IRQ
*/
sp_userdefined:
	rts


_sp_etext:

#-----------------------------------------------------------------------

_sp_dstart:
.section .data

mmd_filename:
	#.asciz "DUMMY0.MMD;1"
	.asciz "MAIN.MMD;1"
.align 2

_sp_dend:

#-----------------------------------------------------------------------

_sp_bstart:
.section .bss

_sp_bend:
