/**
 * \file cd_iso.s
 * CD-ROM ISO File Access API
 * Subdirectories are *not* supported. All files should be in the root.
 */

#ifndef MEGADEV__CD_SUB_ISO_S
#define MEGADEV__CD_SUB_ISO_S

#include "macros.s"
#include "cd_sub_bios.s"

.section .text

/*
-----------------------------------------------------------------------
 CD-ROM Access Result
 The values here are the ones used in Sonic CD
-----------------------------------------------------------------------
*/
# Result OK
.equ	ACCRES_OK,		0x64
# Error in core load_data subroutine
.equ	ACCRES_LOAD_DATA_ERR,	0xff9c
# Error occurred when trying to load file list from directory
.equ	ACCRES_LOAD_DIR_ERR,	0xffff
# File not found when trying to load file
.equ	ACCRES_FILE_NOT_FOUND,	0xfffe
# Error in load_data while trying to load a file
.equ	ACCRES_LOAD_FILE_ERR, 0xfffd

/*
-----------------------------------------------------------------------
 CD-ROM Access Status
 The current task being performed by the access loop
-----------------------------------------------------------------------
*/
.equ	ACCSTAT_IDLE, 			0x0
.equ	ACCSTAT_LOADDIR,		0x1
.equ	ACCSTAT_LOADFILE,	0x2

/*
-----------------------------------------------------------------------
 CD-ROM Access Command Macros
-----------------------------------------------------------------------
*/
# Initialize CD-ROM Access loop
# Should only need to be called once during the SP Init code
.macro CDACC_INIT
	move.w	#0, d0
	jsr			cdrom_access
.endm

# Check status of an Access command
.macro CDACC_CHECK_STATUS
	move.w	#1, d0
	jsr			cdrom_access
.endm

# Load and cache root directory file list
.macro CDACC_LOAD_DIR
	move.w	#2, d0
	jsr			cdrom_access
.endm

# Load a file into a buffer
.macro CDACC_LOAD_FILE
	move.w	#3, d0
	jsr			cdrom_access
.endm

/*
	Convenience sub to get a file loaded
	 IN:
  a0 - Filename string (zero terminated)
	a1 - Pointer to destination data buffer
*/
load_file:
	CDACC_LOAD_FILE				/*load file command*/
0:jbsr		_WAITVSYNC
	CDACC_CHECK_STATUS
	bcs			0b							/*wait for completion*/
	cmpi.w	#ACCRES_OK, d0	/*check status*/
	bne			load_file				/*try again if bad status*/
	rts

/*
	C wrapper for load_file
	void load_file(void *filename, void *buffer)
*/
load_file_c:
	link		a6, #0
	movea.l	8(a6), a0
	movea.l	12(a6), a1
	jbsr		load_file
	unlk		a6
	rts

/*
-----------------------------------------------------------------------
 Access Loop - IRQ Handler
 This should be set up as the Sub CPU Level 2 interrupt handler.
 This MUST be called on every IRQ2 in order for the Access system
 to function.
-----------------------------------------------------------------------
*/
cdrom_access_irq:
	movea.l	cdacc_loop_jump_ptr, a0	/*load the jump ptr*/
	jmp			(a0)										/*and pick up where we left off*/

/*
-----------------------------------------------------------------------
 CD-ROM Access
 General interface for CD-ROM functionality
-----------------------------------------------------------------------
 IN:
  d0 - request command
 OUT:
  none
 BREAK:
  d0-d1
-----------------------------------------------------------------------
*/
cdrom_access:
	PUSHM		a0-a6
	add.w		d0, d0
	move.w	cdrom_access_table(pc,d0.w), d0
	jsr			cdrom_access_table(pc,d0.w)
	POPM		a0-a6
	rts

cdrom_access_table:
	.word		cdrom_access_init - cdrom_access_table
	.word		cdrom_access_status - cdrom_access_table
	.word		cdrom_access_loaddir - cdrom_access_table
	.word		cdrom_access_loadfile - cdrom_access_table

/*
-----------------------------------------------------------------------
 CD-ROM Access Initialize
 Kickstarts the access loop by setting the initial jump ptr and
 command. This should be called once early on (ideally in SP_INIT)
 before using any other Access functions.
-----------------------------------------------------------------------
*/
cdrom_access_init:
	move.l	#cdacc_loop_idle, cdacc_loop_jump_ptr
	move.w	#ACCSTAT_IDLE, cdacc_loop_status
	rts

/*
-----------------------------------------------------------------------
 CD-ROM Access - Load Root Directory
 Loads and caches the names/addresses of files in the root directory.
 This should be called before using any Load File functions.
 (This is basically a wrapper; all the real work further down.)
-----------------------------------------------------------------------
*/
cdrom_access_loaddir:
	move.w	#ACCSTAT_LOADDIR, cdacc_loop_status
	rts

/*
-----------------------------------------------------------------------
 CD-ROM Access - Load File
 Loads a given file into a Sub CPU side buffer without DMA.
-----------------------------------------------------------------------
 IN:
  a0 - Filename string (zero terminated)
	a1 - Pointer to destination data buffer
 OUT:
  none
 BREAK:
  d1
-----------------------------------------------------------------------
*/
cdrom_access_loadfile:
	move.w	#ACCSTAT_LOADFILE, cdacc_loop_status
	move.l	a1, cdrom_transfer_dest_ptr
	lea			cdrom_filename, a1
	#movea.l	a0, a1
	move.w	#0xb, d1
1:move.b	(a0)+, (a1)+
	dbf			d1, 1b
	rts

/*
-----------------------------------------------------------------------
 CD-ROM Access - Find File
-----------------------------------------------------------------------
 Get ptr to cached file list entry for a given filename

 IN:
  a0 - ptr to file name
 OUT:
  ccr set - file not found
  a0 - ptr to file list entry
	d0 - set to 1 when file found
 BREAK:
  d0-d1, a0-a2
-----------------------------------------------------------------------
*/
cdrom_find_file:
	PUSH a2
	# get filename length first
	moveq		#0, d1
	movea.l	a0, a1			/*Put filename in a1*/
	moveq		#0xa, d0		/*max length of filename (without version)*/
0:tst.b		(a1)
	beq			1f					/*Hit 0 - end of filename*/
	cmpi.b	#';', (a1)  /*Hit ; - end of filename*/
	beq			1f
	cmp.b		#' ', (a1)  /*Hit space - end of filename (or invalid)*/
	beq			1f
	addq.w	#1, d1
	addq.w	#1, a1
	dbf			d0, 0b
1:move.w	file_list_count, d0	/*for each file in the cache list*/
	movea.l	a0, a1							/*filename in a1*/
	lea			file_list_cache, a2	/*file list entry in a2*/
	subq.w	#1, d0							/*file count in d0*/
2:bsr			compare_string			/*compare the filenames*/
	beq			3f							/*found the file*/
	adda.w	#0x20, a2				/*not found, move to next file list entry*/
	dbf			d0, 2b
	bra			5f							/*couldn't find file in list*/
3:moveq		#1, d0			/*found the file*/
	movea.l	a2, a0			/*ptr to file list entry in a0*/
4:POP a2
	rts
5:move 		#1, ccr					/* file not found */
	bra			4b

/*
-----------------------------------------------------------------------
 CD-ROM Access - Check Status
 Checks if a requested function within the access loop has completed,
 and if so what returns final status of the request.
-----------------------------------------------------------------------
	IN:
		none
	OUT:
		CARRY flag set - Access request busy
		CARRY flag clear - Access request completed
		d0 - result code
		d1 - if result was OK, contains size of file; if result was 0xfffd,
		     contains number of sectors read; otherwise, not used
-----------------------------------------------------------------------
*/
cdrom_access_status:
	cmpi.w	#ACCSTAT_IDLE, cdacc_loop_status		/*if status is anything but idle*/
	bne			2f																/*then jump down*/
	move.w	cdrom_access_result, d0
	cmpi.w	#ACCRES_OK, d0						/*check for good status*/
	bne			0f												/*not good, jump down*/
	move.l	cdrom_record_size, d1			/*status ok, get size of the last read record*/
	bra			1f
0:cmpi.w	#ACCRES_LOAD_FILE_ERR, d0		/*check for load file subroutine failure*/
	bne			1f
	move.w	sectors_read_count, d1			/*if so, return number of sectors read*/
1:move		#0, ccr				/*access loop completed*/
	rts
2:move		#1, ccr							/*access loop is busy*/
	rts


/*
-----------------------------------------------------------------------
 CD-ROM Access Loop
 The following code will be called via IRQ2 and the loop jump pointer.
 This jump routine and the "cdacc_loop" functions should not be called
 directly.
-----------------------------------------------------------------------
*/
cdacc_loop_idle:
	bsr			break_for_int2
cdacc_loop:
	move.w	cdacc_loop_status, d0
	add.w		d0, d0
	move.w	cdacc_loop_table(pc,d0.w), d0
	jmp			cdacc_loop_table(pc,d0.w)
	rts

cdacc_loop_table:
	.word		cdacc_loop_idle - cdacc_loop_table
	.word		cdacc_loop_loaddir - cdacc_loop_table
	.word		cdacc_loop_loadfile_2M - cdacc_loop_table
/*
	Sonic CD has what seems to be code for loading data specifically
	into PRG RAM and 1M mode Word RAM. These also appear to be unused
	(though this needs to be fully verified). The code for each is nearly
	identical to the standard 2M mode load code that is used, and it's
	unclear why it wasn't refactored into a single dynamic function.
	The code for these is not included here as it is not used by our
	demo, but jumps to them were here in the access loop.
*/
#	.word		cdacc_loop_loadfile_PRG - cdacc_loop_table
#	.word		cdacc_loop_loadfile_1M - cdacc_loop_table

/*
-----------------------------------------------------------------------
 Access Loop - Load file in to Word RAM
-----------------------------------------------------------------------
*/
cdacc_loop_loadfile_2M:
	move.b	#3, cdc_dev_dest			/*set CDC data destination*/
	lea			cdrom_filename, a0		/*point to the filename*/
	bsr			cdrom_find_file				/*find the file; a0 now has pointer to entry*/
	bcs			cdacc_loop_loadfile_err		/*jump down if file not found*/
	move.l	0x18(a0), cdrom_record_start_frame		/*start frame (sector)*/
	move.l	0x1c(a0), d1													/*size of file (in bytes)*/
	move.l	d1, cdrom_record_size
	/*get the file size in sectors by 'dividing' by 2048*/
	/*TODO: cdacc_loop_loaddir actually uses divu... use that here too?*/
	move.l	#1, cdrom_record_frame_count	/*file must be at least 1 sector*/
0:subi.l	#0x800, d1										/*subtract 2048 bytes (1 sector)*/
	ble			1f														/*we've hit the end of the file*/
	addq.l	#1, cdrom_record_frame_count	/*add 1 to the sector count*/
	bra			0b														/*and loop*/
1:bsr			load_data											/*actually get some data*/
2:cmpi.w	#ACCRES_OK, cdrom_access_result	/*any problems?*/
	beq			3f															/*nope*/
	move.w	#ACCRES_LOAD_FILE_ERR, cdrom_access_result /*yup*/
3:move.w	#ACCSTAT_IDLE, cdacc_loop_status	/*set the loop back to idle*/
	bra			cdacc_loop_idle										/*and jump back into the loop*/
cdacc_loop_loadfile_err:
	move.w	#ACCRES_FILE_NOT_FOUND, cdrom_access_result
	bra			3b


/*
-----------------------------------------------------------------------
 Access Loop - Load Root Directory
 Loads and caches the filename, address and size of each file in the
 root directory.
-----------------------------------------------------------------------
*/
cdacc_loop_loaddir:
	move.b	#3, cdc_dev_dest					/*set CDC data destination*/

	# Part 1: find the root directory record
	move.l	#0x10, cdrom_record_start_frame		/*primary VD is at sector 0x10*/
	move.l	#1, cdrom_record_frame_count			/*read one frame (sector)*/
	lea			file_list_cache_buffer, a0		/*our temporary data buffer in a0*/
	move.l	a0, cdrom_transfer_dest_ptr		/*make it the data destination*/
	bsr			load_data											/*actually get data*/
	cmpi.w	#ACCRES_LOAD_DATA_ERR, cdrom_access_result	/*any issues?*/
	beq			cdacc_loop_loaddir_err				/*yup*/
	lea			file_list_cache_buffer, a1					/*PVD is in the buffer now*/
	move.l	0xa2(a1), cdrom_record_start_frame	/*start sector of root dir record */
	move.l	0xaa(a1), d0									/*size of root dir record (bytes) */
	divu.w	#0x800, d0					/*get size in sectors */
	swap		d0									/*check for a remainder */
	tst.w		d0
	beq			0f
	addi.l	#0x10000, d0				/*if there's a remainder, add a sector*/
															/*(value is swapped right now; upper word is sector count)*/
0:swap		d0									/*back to normal order*/
	move.w	d0, record_size

	# Part 2: loop over root dir sectors and build file list
	clr			file_list_count
1:move.l	#1, cdrom_record_frame_count	/*read one frame*/
	lea			file_list_cache_buffer, a1
	move.l	a1, cdrom_transfer_dest_ptr		/*setup destination*/
	bsr			load_data											/*actually get data*/
	cmpi		#ACCRES_LOAD_DATA_ERR, cdrom_access_result	/*any issues?*/
	beq			cdacc_loop_loaddir_err	/*if so, jump down*/
	lea			file_list_cache, a0
	move.w	file_list_count, d0	/*this will be 0 on the sector*/
	mulu.w	#0x20, d0						/*each file entry is 0x20 bytes*/
	# TODO: shift left by 5 instead of mulu?
	# TODO: max number of files? check for space?
	adda.l	d0, a0		/*move up to the latest file entry offset*/
	lea			file_list_cache_buffer, a1
	moveq		#0, d0
2:move.b	0(a1), d0	/*no more entries? (size is 0)*/
	beq			7f				/*no more, jump down*/
	move.b	0x19(a1), 0x17(a0)	/*file flags*/
	move.l	6(a1), 0x18(a0)			/*file start sector*/
	move.l	0xe(a1), 0x1c(a0)		/*file size in bytes*/
	moveq		#0, d1						/*d1 will be filename char index*/
4:move.b	0x21(a1,d1.w), (a0,d1.w)	/*filename*/
	addq.w	#1, d1
	cmp.b		0x20(a1), d1	/*length of filename (including version suffix)*/
	blt			4b						/*not done with filename yet*/
5:cmpi.b	#0xc, d1			/*is filename less than 0xC characters in length?*/
	bge			6f						/*no, jump down*/
	move.b	#' ', (a0, d1.w)		/*yes, fill with spaces until it's 0xC length*/
	addq.w	#1, d1
	bra			5b
6:addq.w	#1, file_list_count	/*this file entry is done, add it to the coung*/
	adda.l	d0, a1			/*move to next entry in dir record (d0 holds dir record length)*/
	adda.l	#0x20, a0		/*move to next entry in the file list*/
	bra			2b					/*and do it all again*/
7:subq.w	#1, record_size	/*any more sectors left in the dir record?*/
	bne			1b			/*yes, jump back and do it all again*/
	move.w	#ACCRES_OK, cdrom_access_result	/*we're good here*/
load_file_list_end:
	move.w	#ACCSTAT_IDLE, cdacc_loop_status	/*free and return to access loop*/
	bra			cdacc_loop_idle
cdacc_loop_loaddir_err:
	move.w	#ACCRES_LOAD_DIR_ERR, cdrom_access_result	/*indicate bad result*/
	bra			load_file_list_end

/*
	Core process to retrieve data from disc to buffer
	Note that this code is quite similar to the example provided in the official
	BIOS Manual (page 44)
	IN:
	 a0 - ptr to start frame/frame count table
	 a1 - ptr to destination buffer
	BREAK:
	 d0, d1
*/
load_data:
	# we want to save the call site in order to properly return, since we'll
	# be messing with the stack by calling break_for_int2
	POP			return_ptr
	move.w	#0, sectors_read_count
	move.w	#0x1e, read_retry_count

load_data_begin:
	move.b	cdc_dev_dest, GA_CDCMODE
	# ROMREADN expects a pointer to two consecutive longs, the first being
	# the start sector and the second being the number of sectors to read
	# that's why it is important for cdrom_record_start_frame and 
	# cdrom_record_frame_count to be stored consecutively in memory
	lea 		cdrom_record_start_frame, a0
	move.l	(a0), d0
	# Here we'll get the start frame value in seconds (CD access is done by
	# timecode of MM:SS:FF). The remainder of this operation is the number
	# of frames that don't make up a full second. We convert this to BCD
	# and will use it later as a way of verifying the data read by the CDC
	divu		#75, d0			/*get the number of seconds (75 frames / second)*/
	swap		d0					/*put the modulus in the lower half*/
	HEX2BCD							/*get the value as bcd*/
	move.b	d0, cdc_frame_check		/*store the value to verify data read later*/
	BIOS_CDCSTOP		/*stop any current CDC transfers*/
	BIOS_ROMREADN		/*have BIOS start the data read*/
	move.w	#0x258, read_timeout

1:bsr			break_for_int2	/*take a break here and come back next VINT*/
2:BIOS_CDCSTAT						/*check CDC status since our read call*/
	bcc			3f							/*we have a sector read to be read*/
	subq.w	#1, read_timeout	/*count down read timeout & try again*/
	bge			1b
	subq.w	#1, read_retry_count	/*count down read retry & try again*/
	bge			load_data_begin
	bra			load_data_err					/*failed completely, jump down*/

3:BIOS_CDCREAD		/*read out the data from the CDC*/
	bcs			4f			/*sector not ready, this shouldn't happen since*/
									/*CDCSTAT said we were good; jump down & try again*/
	move.l	d0, cdc_read_timecode	/*the timecode for the read sector comes back in d0*/
	move.b	cdc_frame_check, d0		/*bring back the frame count we calculated earlier*/
	cmp.b		cdc_read_timecode+2, d0	/*and check it against the frame count from CDC*/
	beq			5f											/*things looks good, let's keep going*/
4:subq.w	#1, read_retry_count	/*count down read retry & try again*/
	bge			load_data_begin
	bra			load_data_err
5:move.w	#0x7ff, d0				/*wait for Data Set Ready flag from CDC*/
	btst		#CDCMODE_DSR_BIT-8, (GA_CDCMODE).l
	dbne		d0, 5b
	bne			6f
	subq.w	#1, read_retry_count	/*no response from CDC in time, retry*/
	bge			load_data_begin
	bra			load_data_err
6:cmpi.b	#2, cdc_dev_dest	/*is this a main CPU read?*/
	beq			load_data_maincpudest		/*if so, jump down; main cpu can't use CDCTRN*/
	movea.l	(cdrom_transfer_dest_ptr), a0	/*setup CDCTRN pointers*/
	lea			cdc_read_timecode, a1
	BIOS_CDCTRN						/*transfer data from CDC to RAM*/
	bcs			7f
	move.b	cdc_frame_check, d0			/*check against our expected frame count again*/
	cmp.b		cdc_read_timecode+2, d0	
	beq			8f										/*frame count is good, move on*/
7:subq.w	#1, read_retry_count	/*frame count didn't match, retry*/
	bge			load_data_begin
	bra			load_data_err
	/*why set ccr here? Calling code expected a status value in RAM, not condition code.
	Probably leftover from example code...?*/
8:move		#0, ccr
	moveq		#1, d1		/*prepare to move to next frame*/
	abcd		d1, d0		/*d0 has cdc_frame_check (as BCD), add one to it*/
	move.b	d0, cdc_frame_check			/*TODO: check if this can be re-arranged*/
	cmpi.b	#0x75, cdc_frame_check	/* check if we're past 75 frames (0 indexed,BCD)*/
	bcs			9f				/*not yet*/
	move.b	#0, cdc_frame_check		/*frame counter rolled past 75, reset our check*/
9:BIOS_CDCACK				/*send ack to CDC*/
	move.w	#6, read_timeout		/*reset error counters*/
	move.w	#0x1e, read_retry_count
	addi.l	#0x800, cdrom_transfer_dest_ptr	/*move the dest buffer up a sector*/
	addq.w	#1, sectors_read_count		/*add to the sectors read count*/
	addq.l	#1, cdrom_record_start_frame	/*move to the next frame*/
	subq.l	#1, cdrom_record_frame_count	/*countdown frames to be read*/
	bgt			2b					/*and loop back if there are still frames pending*/
	move.w	#ACCRES_OK, cdrom_access_result	/*indicate we completed successfully*/
load_data_end:
	move.b	cdc_dev_dest, GA_CDCMODE
	movea.l	return_ptr, a0	/*return to the original call site*/
	jmp			(a0)
load_data_err:
	move.w	#ACCRES_LOAD_DATA_ERR, cdrom_access_result
	bra			load_data_end
	# not entirely certain how this works with Main CPU being the destination,
	# since I'm not 100% clear on the effect of CDC mode
	# in any case, our tutorial doesn't use it
load_data_maincpudest:
	move.w	#6, read_timeout
1:bsr			break_for_int2
	btst		#7, GA_CDCMODE	/*check EDT*/
	bne			9b
	subq.w	#1, read_timeout
	bge			1b
	bra			load_data_err

/*
	Compare strings at a1 and a2
	IN:
		a1 - ptr to string 1
		a2 - ptr to string 2
		d1 - length
	REKT: none
*/
compare_string:
	PUSHM		d1/a1-a2
1:cmpm.b	(a1)+, (a2)+
	bne			2f
	dbf			d1, 1b
	moveq		#0, d1
2:POPM		d1/a1-a2
	rts

/*
	Pops the last address from the stack and stores
	in the INT2 call ptr
	Should be called as subroutine rather than directly
*/
break_for_int2:
	POP			cdacc_loop_jump_ptr
	rts

.section .bss
cdacc_loop_jump_ptr:
	.long 0

# the two longs are the table used by ROMREADN/ROMREADE, so
# it is necessary that there are two consecutive long values!
cdrom_record_start_frame:
	.long 0
cdrom_record_frame_count:
	.long 0

cdrom_transfer_dest_ptr:
	.long 0

cdrom_record_size:
	.long 0

cdacc_loop_status:
	.word 0

cdrom_access_result:
	.word 0

.align 2

cdrom_filename:
	# 8.3 filename + version (2 bytes) = 14 bytes
	.space 0xe

sectors_read_count:
	.word	0
read_timeout:
	.word 0
read_retry_count:
	.word 0

cdc_read_timecode:
	.long	0
cdc_frame_check:
	.byte	0

.align 2
return_ptr:
	.long 0
cdc_dev_dest:		# CDC device destination
	.byte 0
.align 2

file_list_count:
	.word 0

record_size:		/* in sectors*/
	.word 0

.align 0x10
file_list_cache:
# 0x20 per entry * 256 files = 0x2000 size
# (though theoretically it could hold a bit more, by
# bleeding into the following buffer space)
	.space 0x2000

file_list_cache_buffer:
	.space 0x800		/* size of a single sector */

#endif
