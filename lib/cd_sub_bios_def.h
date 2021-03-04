/**
 * \file cd_sub_bios_def.h
 * BIOS ROM system call vector and function ID definitions
 * (Intended for Sub CPU usage only)
 */

#ifndef MEGADEV__CD_SUB_BIOS_DEF_H
#define MEGADEV__CD_SUB_BIOS_DEF_H

/**
 * System and BIOS vectors
 */
#define _BOOTSTAT 0x00005EA0

#define _WAITVSYNC 0x00005F10

/**
 * CD Boot system call vector
 */
#define _CDBOOT 0x00005F1C

#define _CDSTAT 0x00005E80

/**
 * Exception/Interrupt vectors
 */
#define _ADRERR 0x00005F40
#define _CHKERR 0x00005F52
#define _CODERR 0x00005F46
#define _DEVERR 0x00005F4C
#define _LEVEL1 0x00005F76
#define _LEVEL2 0x00005F7C
#define _LEVEL3 0x00005F82 /*TIMER INTERRUPT*/
#define _LEVEL4 0x00005F88
#define _LEVEL5 0x00005F8E
#define _LEVEL6 0x00005F94
#define _LEVEL7 0x00005F9A
#define _NOCOD0 0x00005F6A
#define _NOCOD1 0x00005F70
#define _SETJMPTBL 0x00005F0A
#define _SPVERR 0x00005F5E
#define _TRACE 0x00005F64
#define _TRAP00 0x00005FA0
#define _TRAP01 0x00005FA6
#define _TRAP02 0x00005FAC
#define _TRAP03 0x00005FB2
#define _TRAP04 0x00005FB8
#define _TRAP05 0x00005FBE
#define _TRAP06 0x00005FC4
#define _TRAP07 0x00005FCA
#define _TRAP08 0x00005FD0
#define _TRAP09 0x00005FD6
#define _TRAP10 0x00005FDC
#define _TRAP11 0x00005FE2
#define _TRAP12 0x00005FE8
#define _TRAP13 0x00005FEE
#define _TRAP14 0x00005FF4
#define _TRAP15 0x00005FFA
#define _TRPERR 0x00005F58
#define _USERCALL0 0x00005F28 /* SP Init */
#define _USERCALL1 0x00005F2E /* SP Main */
#define _USERCALL2 0x00005F34 /* SP INT2 */
#define _USERCALL3 0x00005F3A /* SP User Interrupt */
#define _USERMODE 0x00005EA6

//******************************************************************************
// BACKUP RAM FUNCTIONS
//******************************************************************************

/**
 * Backup RAM (BRAM) system call vector
 */
#define _BURAM 0x00005F16

/**
 * BIOS_BRMINIT (BRAM)
 * Prepares to write into and read from Back-Up Ram.
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
 */
#define BRMINIT 0x0000

/**
 * BIOS_BRMSTAT (BRAM)
 * Returns how much Back-Up RAM has been used.
#
# input:
#   a1.l  pointer to display string buffer (size: 12 bytes)
#
# returns:
#   d0.w  number of blocks of free area
#   d1.w  number of files in directory
 */
#define BRMSTAT 0x0001

/**
 * BIOS_BRMSERCH (BRAM)
 * Searches for the desired file in Back-Up Ram.  The file
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
 */
#define BRMSERCH 0x0002

/**
 * BIOS_BRMREAD (BRAM)
 * reads data from Back-Up RAM.
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
 */
#define BRMREAD 0x0003

/**
 * BIOS_BRMWRITE (BRAM)
 * Writes data in Back-Up RAM.
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
 */
#define BRMWRITE 0x0004

/**
 * BIOS_BRMDEL (BRAM)
 * Deletes data on Back-Up Ram.
#
# input:
#   a0.l  pointer to parameter (file name) table
#
# returns:
#   cc    deleted
#   cs    not found
 */
#define BRMDEL 0x0005

/**
 * BIOS_BRMFORMAT (BRAM)
 * First initializes the directory and then formats the
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
 */
#define BRMFORMAT 0x0006

/**
 * BIOS_BRMDIR (BRAM)
 * Reads directory
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
 */
#define BRMDIR 0x0007

/**
 * BIOS_BRMVERIFY (BRAM)
 * Checks data written on Back-Up Ram.
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
 */
#define BRMVERIFY 0x0008

/**
 * CD Boot function codes
 * For used with the _CDBOOT vector defined above
 * Function ID should be placed in d0 register
 */
#define CBTINIT 0x0000
#define CBTINT 0x0001
#define CBTOPENDISC 0x0002
#define CBTOPENSTAT 0x0003
#define CBTCHKDISC 0x0004
#define CBTCHKSTAT 0x0005
#define CBTIPDISC 0x0006
#define CBTIPSTAT 0x0007
#define CBTSPDISC 0x0008
#define CBTSPSTAT 0x0009

//******************************************************************************
// CD BIOS FUNCTIONS
//******************************************************************************

/**
 * \fn _CDBIOS
 * \brief CD BIOS system call vector
 * \param[in] D0.w Syscall ID
 */
#define _CDBIOS 0x00005F22

/**
 * \def _MSCSTOP
 * \brief Stops playing CD audio if it is playing
 */
#define _MSCSTOP    0x0002

/**
 * 
 * \def _MSCPAUSEON
 * \brief Pauses the drive when a track is playing. 
 * 
 * \note If the drive is left paused it will stop after a programmable delay
 * (see \ref _CDBPAUSE)
 */
#define _MSCPAUSEON 0x0003

/**
 * \def _MSCPAUSEOFF
 * \brief Resumes playing a track after a pause
 * \ingroup bios_syscall bios_cdda
 *
 * \note If the drive has timed out and stopped, the BIOS will seek to the pause
 * time (with the attendant delay) and resume playing
 */
#define _MSCPAUSEOFF 0x0004

/**
 * \def _MSCSCANFF
 * \brief Starts playing from the current position in fast forward
 */
#define _MSCSCANFF 0x0005

/**
 * \def _MSCSCANFR
 * \brief Starts playing from the current position in fast reverse
 */
#define _MSCSCANFR 0x0006

/**
 * \def _MSCSCANOFF
 * \brief Returns to normal play mode
 * 
 * \note If the drive waspaused before the scan was initiated, it will be
 * returned to pause.
 */
#define _MSCSCANOFF 0x0007

/**
 * \def _ROMPAUSEON
 * \brief Stops reading data into the CDC and pauses
 */
#define _ROMPAUSEON 0x0008

/**
 * \def _ROMPAUSEOFF
 * \brief Resumes reading data into the CDC from the current logical sector
 */
#define _ROMPAUSEOFF 0x0009

/**
 * \def _DRVOPEN
 * \brief Opens the CD drive door
 * 
 * \note This is only applicable to Model 1 hardware.
 */
#define _DRVOPEN 0x000A

/**
 * \def _DRVINIT
 * \brief Closes the disk tray and reads the TOC from the CD
 * \param[in] A0.l Pointer to initilization parameters
 *
 * \details Takes a pointer to two bytes (initialization params):
 *  byte 1 - track number from which to read TOC (normally 0x01); if bit 7 of
 *           this value is set, BIOS will start to play the first track
             automatically
 *  byte 2 - last track to read (0xff will read all tracks)
 *
 * Pauses for 2 seconds after reading the TOC. Waits for a DRVOPEN request if
 * there is no disk in the drive.
 */
#define _DRVINIT 0x0010

/**
 * BIOS_MSCPLAY (CD-DA)
 * Start CD audio playback at the specified track; continue playing through
 * subsequent tracks
 *
 * IN:
 *  A0 - pointer to track number (16 bit value)
 * OUT:
 *  none
 */
#define MSCPLAY 0x0011

/**
 * BIOS_MSCPLAY1 (CD-DA)
 * Play the specified track once then pause
 *
 * IN:
 *  A0 - pointer to track number (16 bit value)
 * OUT:
 *  none
 */
#define MSCPLAY1 0x0012

/**
 * BIOS_MSCPLAYR (CD-DA)
 * Play the specified track on repeat
 *
 * IN:
 *  A0 - pointer to track number (16 bit value)
 * OUT:
 *  none
 */
#define MSCPLAYR 0x0013

/**
 * BIOS_MSCPLAYT (CD-DA)
 * Starts playing from the specified time
 *
 * IN:
 *  A0 - pointer to BCD time code in the format mm:ss:ff:00 (32 bit value)
 * OUT:
 *  none
 */
#define MSCPLAYT 0x0014

/**
 * BIOS_MSCSEEK (CD-DA)
 * Seek to the beginning of the specified track and pause
 *
 * IN:
 *  A0 - pointer to track number (16 bit value)
 * OUT:
 *  none
 */
#define MSCSEEK 0x0015

/**
 * BIOS_MSCSEEKT - Seeks to a specified time.
 *
 * IN:
 *  A0 - pointer to BCD time code in the format mm:ss:ff:00 (32 bit value)
 * OUT:
 *  none
 */
#define MSCSEEKT 0x0016

/**
 * BIOS_ROMREAD (CD-ROM)
 * Begins reading data from the CDROM at the designated logical sector
 * Executes a CDCSTART to begin the read, but does not stop automatically
 * ROMREAD actually pre-seeks by 2 sectors, but doesn't start passing data
 * to the CDC until the desired sector is reached.
 *
 * IN:
 *  A0 - pointer to the logical sector number (32 bit value)
 * OUT:
 *  none
 */
#define ROMREAD 0x0017

/**
 * BIOS_ROMSEEK (CD-ROM)
 * Seeks to the designated logical sector and pauses.
 *
 * IN:
 *  A0 - pointer to the logical sector number (32 bit value)
 * OUT:
 *  none
 */
#define ROMSEEK 0x0018

/**
 * BIOS_MSCSEEK1 (CD-DA)
 * Seek to the beginning of the selected track and pause
 * When the BIOS detects a pause state, the track is played once
 *
 * IN:
 *  A0 - pointer to track number (16 bit value)
 * OUT:
 *  none
 */
#define MSCSEEK1 0x0019

#define TESTENTRY 0x001E
#define TESTENTRYLOOP 0x001F

/**
 * BIOS_ROMREADN (CD-ROM)
 * Same function as ROMREAD, but stops after reading the requested number of
 * sectors
 *
 * IN:
#   A0 - address of a 32 bit sector number and 32 bit sector count
#           dc.l    0x00000001   # First sector to read
#           dc.l    0x00001234   # Number of sectors to read
 * OUT:
 *  none
 */
#define ROMREADN 0x0020

/**
 * BIOS_ROMREADE (CD-ROM)
 * Same as ROMREAD, but reads between two logical sectors.
#
# input:
#   a0.l  address of table of 32 bit logical sector numbers
#           dc.l    0x00000001   # First sector to read
#           dc.l    0x00000123   # Last sector to read
 * OUT:
 *  none
 */
#define ROMREADE 0x0021

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDBCHK (Misc)
 * Querys the BIOS on the status of the last command.
# Returns success if the command has been executed, not if it's complete.
# This means that CDBCHK will return success on a seek command once the
# seek has started, NOT when the seek is actually finished.
 *
 * IN:
 *  A0 - pointer to the logical sector number (32 bit value)
 * OUT:
 *  CC - Command has been executed
 *  CS - BIOS is busy
 */
#define CDBCHK 0x0080

/**
 * BIOS_CDBSTAT
 *
 * IN:
 *  none
 * OUT:
 *  A0 - pointer to BIOS status table
 */
#define CDBSTAT 0x0081

/**
 * BIOS_CDBTOCWRITE (Misc)
 * Writes data to the TOC in memory.  Don't write to
# the TOC while the BIOS is performing a DRVINIT.
#
# input:
#   a0.l  address of a table of TOC entries to write to the TOC.  Format
#         of the entries is mm:ss:ff:## where ## is the track number.
#
# returns:
#   nothing
 */
#define CDBTOCWRITE 0x0082

/**
 * BIOS_CDBTOCREAD (Misc)
 * Gets the time for the specified track from the TOC.
# If the track isn't in the TOC, the BIOS will either return the time of
# the last track read or the beginning of the disk.  Don't call this
# function while the BIOS is loading the TOC (see DRVINIT).
#
# input:
#   d1.w  16 bit track number
#
# returns:
#   d0.l  BCD time of requested track in mm:ss:ff:## format where ## is
#         the requested track number or 00 if there was an error
#
#   d1.b  Track type:
#           0x00 = CD-DA track
#           0xFF = CD-ROM track
*/
#define CDBTOCREAD 0x0083

/**
 * BIOS_CDBPAUSE (Misc)
 * Sets the delay time before the BIOS switches from
# pause to standby.  Normal ranges for this delay time are 0x1194 - 0xFFFE.
# A delay of 0xFFFF prevents the drive from stopping, but can  damage the
# drive if used improperly.
#
# input:
#   d1.w  16 bit delay time
#
# returns:
#   nothing
 */
#define CDBPAUSE 0x0084

/**
 * BIOS_FDRSET (Fader)
 * Sets the audio volume.  If bit 15 of the volume parameter
# is 1, sets the master volume level.  There's a delay of up to 13ms
# before the volume begins to change and another 23ms for the new volume
# level to take effect.  The master volume sets a maximum level which the
# volume level can't exceed.
#
# input:
#   d1.w  16 bit volume         (0x0000 = min    0x0400 = max)
#         16 bit master volume  (0x8000 = min    0x8400 = max)
#
# returns:
#   nothing
 */
#define FDRSET 0x0085

/**
 * BIOS_FDRCHG (Fader)
 * Ramps the audio volume from its current level to a new
# level at the requested rate.  As in FDRSET, there's a delay of up to
# 13ms before the change starts.
#
# input:
#   d1.l  32 bit volume change
#         high word:  new 16 bit volume   (0x0000 = min    0x0400 = max)
#         low word:   16 bit rate in steps/vblank
#                     0x0001 = slow
#                     0x0200 = fast
#                     0x0400 = set immediately
#
# returns:
#   nothing
 */
#define FDRCHG 0x0086

/**
 * BIOS_CDCSTART (CDC)
 * Starts reading data from the current logical sector
# into the CDC.  The BIOS pre-seeks by 2 to 4 sectors and data read
# actually begins before the requested sector.  It's up to the caller
# to identify the correct starting sector (usually by checking the time
# codes in the headers as they're read from the CDC buffer).
#
# input:
#   none
#
# returns:
#   nothing
 */
#define CDCSTART 0x0087

#define CDCSTARTP 0x0088

/**
 * BIOS_CDCSTOP (CDC)
 * Stops reading data into the CDC.  If a sector is being
# read when CDCSTOP is called, it is discarded
#
# input:
#   none
#
# returns:
#   nothing
 */
#define CDCSTOP 0x0089

/**
 * BIOS_CDCSTAT (CDC)
 * Queries the CDC buffer.  If no sector is ready for
# read, the carry bit will be set.  Up to 5 sectors can be buffered in
# the CDC buffer.
#
# input:
#   none
#
# returns:
#   cc  Sector available for read
#   cs  No sectors available
 */
#define CDCSTAT 0x008A

/**
 * BIOS_CDCREAD (CDC)
 * If a sector is ready in the CDC buffer, the BIOS prepares to send the sector
 * to the current device destination.  Make sure to set the device destination
 * BEFORE calling CDCREAD.  If a sector is ready, the carry bit will be cleared
 * on return and it's necessary to respond with a call to CDCACK.
#
# input:
#   none
#
# returns:
#   cc    Sector ready for transfer
#   d0.l  Sector header in BCD mm:ss:ff:md format where md is sector mode
#           0x00 = CD-DA
#           0x01 = CD-ROM mode 1
#           0x02 = CD-ROM mode 2
#   cs    Sector not ready
 */
#define CDCREAD 0x008B

/**
 * BIOS_CDCTRN (CDC)
 * Uses the Sub-CPU to read one sector into RAM.  The
# device destination must be set to SUB-CPU read before calling CDCTRN.
#
# input:
#   a0.l  address of sector destination buffer (at least 2336 bytes)
#   a1.l  address of header destination buffer (at least 4 bytes)
#
# returns:
#   cc    Sector successfully transferred
#   cs    Transfer failed
#   a0.l  Next sector destination address (a0 + 2336)
#   a1.l  Next header destination address (a1 + 4)
 */
#define CDCTRN 0x008C

/**
 * BIOS_CDCACK (CDC)
 * Informs the CDC that the current sector has been read
# and the caller is ready for the next sector.
#
# input:
#   none
#
# returns:
#   nothing
 */
#define CDCACK 0x008D

/**
 * BIOS_SCDINIT (Subcode)
 * Initializes the BIOS for subcode reads.
#
# input:
#   a0.l  address of scratch buffer (at least 0x750 long)
#
# returns:
#   nothing
 */
#define SCDINIT 0x008E

/**
 * BIOS_SCDSTART (Subcode)
 * Enables reading of subcode data by the CDC.
#
# input:
#   d1.w  Subcode processing mode
#           0 = --------
#           1 = --RSTUVW
#           2 = PQ------
#           3 = PQRSTUVW
#
# returns:
#   nothing
 */
#define SCDSTART 0x008F

/**
 * BIOS_SCDSTOP (Subcode)
 * Disables reading of subcode data by the CDC.
#
# input:
#   none
#
# returns:
#   nothing
 */
#define SCDSTOP 0x0090

/**
 * BIOS_SCDSTAT (Subcode)
 * Checks subcode error status.
#
# input:
#   none
#
# returns:
#   d0.l  errqcodecrc / errpackcirc / scdflag / restrcnt
#   d1.l  erroverrun / errpacketbufful / errqcodefufful / errpackfufful
 */
#define SCDSTAT 0x0091

/**
 * BIOS_SCDREAD (Subcode)
 * Reads R through W subcode channels.
#
# input:
#   a0.l  address of subcode buffer (24 bytes minimum)
#
# returns:
#   cc    Read successful
#   cs    Read failed
#   a0.l  address of next subcode buffer (a0.l + 24)
 */
#define SCDREAD 0x0092

/**
 * BIOS_SCDPQ (Subcode)
 * Gets P & Q codes from subcode.
#
# input:
#   a0.l  address of Q code buffer (12 bytes minimum)
#
# returns:
#   cc    Read successful
#   cs    Read failed
#   a0.l  address of next Q code buffer (a0.l + 12)
 */
#define SCDPQ 0x0093

/**
 * BIOS_SCDPQL (Subcode)
 * Gets the last P & Q codes.
#
# input:
#   a0.l  address of Q code buffer (12 bytes minimum)
#
# returns:
#   cc    Read successful
#   cs    Read failed
#   a0.l  address of next Q code buffer (a0.l + 12)
 */
#define SCDPQL 0x0094

#define LEDREADY 0
#define LEDDISCIN 1
#define LEDACCESS 2
#define LEDSTANDBY 3
#define LEDERROR 4
#define LEDMODE5 5
#define LEDMODE6 6
#define LEDMODE7 7

/**
 * BIOS_LEDSET (Misc)
 * Controls the Ready and Access LED's on the front panel
# of the CD unit.
#
# input:
#   d1.w  MODE          Ready (green)   Access (red)    System Indication
#         ---------------------------------------------------------------
#                           off             off         only at reset
#         LEDREADY (0)      on              blink       CD ready / no disk
#         LEDDISCIN (1)     on              off         CD ready / disk ok
#         LEDACCESS (2)     on              on          CD accessing
#         LEDSTANDBY (3)    blink           off         standby mode
#         LEDERROR (4)      blink           blink       reserved
#         LEDMODE5 (5)      blink           on          reserved
#         LEDMODE6 (6)      off             blink       reserved
#         LEDMODE7 (7)      off             on          reserved
#         LEDSYSTEM (?)                                 rtn ctrl to BIOS
#
# returns:
#   nothing
 */
#define LEDSET 0x0095

/**
 * BIOS_CDCSETMODE (CDC)
 * Tells the BIOS which mode to read the CD in.  Accepts
# bit flags that allow selection of the three basic CD modes as follows:
#
#       Mode 0 (CD-DA)                              2
#       Mode 1 (CD-ROM with full error correction)  0
#       Mode 2 (CD-ROM with CRC only)               1
#
# input:
#   d1.w  FEDCBA9876543210
#                     ####
#                     ###+--> CD Mode 2
#                     ##+---> CD-DA mode
#                     #+----> transfer error block with data
#                     +-----> re-read last data
#
# returns:
#   nothing
 */
#define CDCSETMODE 0x0096

#define WONDERREQ 0x0097
#define WONDERCHK 0x0098

#endif
