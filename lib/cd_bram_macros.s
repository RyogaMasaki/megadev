/**
-----------------------------------------------------------------------
 cd_bram.s
 Backup RAM (BRAM) access


#-----------------------------------------------------------------------
# NOTE:  The backup ram on the super target devlopment systems is write
#         protected if the production Boot Rom is being used.  A
#         Development Boot Rom must be obtained before the backup ram can
#         be used.
#
#        The name of the save game files must be registered with SOJ before
#         a game can be shipped.
#
#        Please make sure to read the CD Software Standards section in the
#         manual.  There is a section on backup ram standards that must be
#         followed.
#
#        For a full description of each Back-Up Ram function, see the BIOS
#         section of the CD manual.
#
#        Some of the Back-Up RAM functions require a string buffer to
#         be passed into the function.  Some of these functions return
#         0 terminated text strings.
#-------------------------------------------------------------------------

-----------------------------------------------------------------------
*/

.ifndef MEGADEV__CD_BRAM_MACROS_S
.set MEGADEV__CD_BRAM_MACROS_S, 1

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
.macro BIOS_BRMINIT
	BURAM #BRMINIT
.endm

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
.macro BIOS_BRMSTAT
	BURAM #BRMSTAT
.endm

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
.macro BIOS_BRMSERCH
	BURAM #BRMSERCH
.endm

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
.macro BIOS_BRMREAD
	BURAM #BRMREAD
.endm

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
.macro BIOS_BRMWRITE
	BURAM #BRMWRITE
.endm

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
.macro BIOS_BRMDEL
	BURAM #BRMDEL
.endm

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
.macro BIOS_BRMFORMAT
	BURAM #BRMFORMAT
.endm

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
.macro BIOS_BRMDIR
	BURAM #BRMDIR
.endm

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
.macro BIOS_BRMVERIFY
	BURAM #BRMVERIFY
.endm

.endif