/**
 * \file cd_bram.s
 * Internal Backup RAM (BRAM)
 */

#ifndef MEGADEV__CD_SUB_BRAM_S
#define MEGADEV__CD_SUB_BRAM_S

#include "macros.s"
#include "cd_sub_bram_def.h"

/*
-----------------------------------------------------------------------
 BURAM - Calls the Backup Ram with a specified function number.
 Assumes that all preparatory and cleanup work is done externally.

 IN:
  fcode Backup Ram function code

 OUT:
  none
-----------------------------------------------------------------------
*/
.macro BURAM fcode
	move.w    \fcode,d0
	jsr       _BURAM
.endm


/*
#-----------------------------------------------------------------------
# BIOS_BRMINIT - Prepares to write into and read from Back-Up Ram.
#
# input:
#   a0.l  pointer to scratch ram (size 0x640 bytes).
#
#   a1.l  pointer to the buffer for display strings (size: 12 bytes)
#
# returns:
#   cc    SEGA formatted RAM is present
#   cs    Not formatted or no RAM
#   d0.w  size of backup RAM  0x2(000) ~ 0x100(000)  bytes
#   d1.w  0 : No RAM
#         1 : Not Formatted
#         2 : Other Format
#   a1.l  pointer to display strings
#-----------------------------------------------------------------------
*/
.macro BIOS_BRMINIT
	BURAM #BRMINIT
.endm

/*
#-----------------------------------------------------------------------
# BIOS_BRMSTAT - Returns how much Back-Up RAM has been used.
#
# input:
#   a1.l  pointer to display string buffer (size: 12 bytes)
#
# returns:
#   d0.w  number of blocks of free area
#   d1.w  number of files in directory
#-----------------------------------------------------------------------
*/
.macro BIOS_BRMSTAT
	BURAM #BRMSTAT
.endm

/*
#-----------------------------------------------------------------------
# BIOS_BRMSERCH - Searches for the desired file in Back-Up Ram.  The file
#                  names are 11 ASCII characters terminated with a 0.
#
# input:
#   a0.l  pointer to parameter (file name) table
#             file name = 11 ASCII chars [0~9 A~Z_]   0 terminated
#
# returns:
#   cc    file name found
#   cs    file name not found
#   d0.w  number of blocks
#   d1.b  MODE
#         0 : normal
#        -1 : data protected (with protect function)
#   a0.l  backup ram start address for search
#-----------------------------------------------------------------------
*/
.macro BIOS_BRMSERCH
	BURAM #BRMSERCH
.endm

/*
#-----------------------------------------------------------------------
# BIOS_BRMREAD - reads data from Back-Up RAM.
#
# input:
#   a0.l  pointer to parameter (file name) table
#   a1.l  pointer to write buffer
#
# returns:
#   cc    Read Okay
#   cs    Error
#   d0.w  number of blocks
#   d1.b  MODE
#         0 : normal
#        -1 : data protected
#-----------------------------------------------------------------------
*/
.macro BIOS_BRMREAD
	BURAM #BRMREAD
.endm

/*
#-----------------------------------------------------------------------
# BIOS_BRMWRITE - Writes data in Back-Up RAM.
#
# input:
#   a0.l  pointer to parameter (file name) table
#          flag.b       0x00: normal
#                       0xFF: encoded (with protect function)
#          block_size.w 0x00: 1 block = 0x40 bytes
#                       0xFF: 1 block = 0x20 bytes
#   a1.l  pointer to save data
#
# returns:
#   cc    Okay, complete
#   cs    Error, cannot write in the file
#-----------------------------------------------------------------------
*/
.macro BIOS_BRMWRITE
	BURAM #BRMWRITE
.endm

/*
#-----------------------------------------------------------------------
# BIOS_BRMDEL - Deletes data on Back-Up Ram.
#
# input:
#   a0.l  pointer to parameter (file name) table
#
# returns:
#   cc    deleted
#   cs    not found
#-----------------------------------------------------------------------
*/
.macro BIOS_BRMDEL
	BURAM #BRMDEL
.endm

/*
#-----------------------------------------------------------------------
# BIOS_BRMFORMAT - First initializes the directory and then formats the
#                   Back-Up RAM
#
#                  Call BIOS_BRMINIT before calling this function
#
# input:
#   none
#
# returns:
#   cc    Okay, formatted
#   cs    Error, cannot format
#-----------------------------------------------------------------------
*/
.macro BIOS_BRMFORMAT
	BURAM #BRMFORMAT
.endm

/*
#-----------------------------------------------------------------------
# BIOS_BRMDIR - Reads directory
#
# input:
#   d1.l  H: number of files to skip when all files cannot be read in one try
#         L: size of directory buffer (# of files that can be read in the
#             directory buffer)
#   a0.l  pointer to parameter (file name) table
#   a1.l  pointer to directory buffer
#
# returns:
#   cc    Okay, complete
#   cs    Full, too much to read into directory buffer
#-----------------------------------------------------------------------
*/
.macro BIOS_BRMDIR
	BURAM #BRMDIR
.endm

/*
#-----------------------------------------------------------------------
# BIOS_BRMVERIFY - Checks data written on Back-Up Ram.
#
# input:
#   a0.l  pointer to parameter (file name) table
#          flag.b       0x00: normal
#                       0xFF: encoded (with protect function)
#          block_size.w 0x00: 1 block = 0x40 bytes
#                       0xFF: 1 block = 0x20 bytes
#   a1.l  pointer to save data
#
# returns:
#   cc    Okay
#   cs    Error
#   d0.w  Error Number
#        -1 : Data does not match
#         0 : File not found
#-----------------------------------------------------------------------
*/
.macro BIOS_BRMVERIFY
	BURAM #BRMVERIFY
.endm

.section .text

/**
 * bram_init
 * Convenience wrapper for BRMINIT BIOS call, primarily for use with C since
 * it seems we cannot pass the status register back up, which is where the 
 * overall good/bad status is stored. We solve this by adding an additional,
 * "good" status to the returned value in d1.
 * IN:
 *  None
 * OUT:
 *  d0.w - BRAM size
 *         0x2(000) to 0x100(000) bytes
 *  d1.w - RAM status
 *         0: No RAM present
 *         1: Unformatted
 *         2: Other format
 *         3: Formatted RAM present
 *  a1.l - Pointer to display string
 * BREAK:
 *  d0-d1/a0-a1
 */
FUNC bram_init
  lea bram_work_ram, a0
  lea bram_string_buffer, a1
  BIOS_BRMINIT
	bcs 2f
  move.w #3, d1
2:rts

/**
 * bram_find_file
 * Convenience wrapped for BRMSERCH, primarily for use with C
 * Sets d0 to -1 if file is not found, otherwise output is the same as
 * the syscall description.
 * IN:
 *  a0.l - Pointer to filename
 *         Filename is 11 ASCII chars [0~9 A~Z_] in length, \0 terminated
 * OUT:
 *  d0.w - File size in blocks
 *  d0.l - If value is -1 (0xffffffff), file was not found
 *  d1.b - File mode
 *            0 : normal
 *         0xff : data protected (need to use protection function)
 *  a0.l - Pointer to start address
 *
 * BREAK:
 * d0-d1/a0-a1
 */
FUNC bram_find_file
  BIOS_BRMSERCH
  bcc 1f
  move.l #0xffffffff, d0
1:rts

.section .bss
bram_string_buffer: .space 12
bram_work_ram: .space 0x640

#endif
