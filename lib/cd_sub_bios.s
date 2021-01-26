
#include "cd_sub_bios_def.h"

/**
 * -----------------------------------------------------------------------------
 * CDBIOS
 * Calls the BIOS with a specified function number.
 * 
 *  fcode - BIOS function code
 * -----------------------------------------------------------------------------
*/
.macro CDBIOS fcode
	move.w    \fcode,d0
  jsr       _CDBIOS
.endm

/**
 * -----------------------------------------------------------------------------
 * DRIVE FUNCTIONS
 * -----------------------------------------------------------------------------
 */

/**
 * -----------------------------------------------------------------------------
 * BIOS_DRVINIT
 * 
 * Closes the disk tray and reads the TOC from the CD
 * 
 * Takes a pointer to two bytes (initialization params):
 *  byte 1 - track number from which to read TOC (normally 0x01); if bit 7 of
 *           this value is set, BIOS will start to play the first track
             automatically
 *  byte 2 - last track to read (0xff will read all tracks)
 * 
 * Pauses for 2 seconds after reading the TOC. Waits for a DRVOPEN request if
 * there is no disk in the drive.
 * 
 * IN:
 *  A0 - pointer to initialization parameters
 * -----------------------------------------------------------------------------
 */
.macro BIOS_DRVINIT
	CDBIOS #DRVINIT
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_DRVOPEN
 * Opens the drive door; only applicable to Model 1 hardware
 */
.macro BIOS_DRVOPEN
	CDBIOS #DRVOPEN
.endm


/**
 * -----------------------------------------------------------------------------
 * CD-DA FUNCTIONS
 * -----------------------------------------------------------------------------
 */

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCSTOP
 * Stops playing CD audio if it is playing
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCSTOP
	CDBIOS #MSCSTOP
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCPLAY
 * Starts CD audio playback at the specified track; continues playing through
 * subsequent tracks
 *
 * IN:
 *  A0 - pointer to track number (16 bit value)
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCPLAY
	CDBIOS #MSCPLAY
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCPLAY1
 * Plays the specified track once and pauses
 * 
 * IN:
 *  A0 - pointer to track number (16 bit value)
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCPLAY1
	CDBIOS #MSCPLAY1
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCPLAYR
 * Plays the specified track on repeat
 * 
 * IN:
 *  A0 - pointer to track number (16 bit value)
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCPLAYR
	CDBIOS #MSCPLAYR
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCPLAYT
 * Starts playing from the specified time
 * 
 * IN:
 *  A0 - pointer to BCD time code in the format mm:ss:ff:00 (32 bit value)
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCPLAYT
	CDBIOS #MSCPLAYT
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCSEEK
 * Seeks to the beginning of the specified track and pauses
 * 
 * IN:
 *  A0 - pointer to track number (16 bit value)
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCSEEK
	CDBIOS #MSCSEEK
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCSEEK1 - Seeks to the beginning of the selected track and pauses.
# Once the BIOS detects a pause state, it plays the track once.
#
# input:
#   a0.l  address of a 16 bit track number
#
# returns:
#   nothing
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCSEEK1
	CDBIOS #MSCSEEK1
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCSEEKT - Seeks to a specified time.
#
# input:
#   a0.l  address of a 32 bit BCD time code in the format mm:ss:ff:00
#
# returns:
#   nothing
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCSEEKT
	CDBIOS #MSCSEEKT
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCPAUSEON - Pauses the drive when a track is playing.  If the
# drive is left paused it will stop after a programmable delay (see
# CDBPAUSE).
#
# input:
#   none
#
# returns:
#   nothing
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCPAUSEON
	CDBIOS #MSCPAUSEON
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCPAUSEOFF - Resumes playing a track after a pause.  If the drive
# has timed out and stopped, the BIOS will seek to the pause time (with
# the attendant delay) and resume playing.
#
# input:
#   none
#
# returns:
#   nothing
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCPAUSEOFF
	CDBIOS #MSCPAUSEOFF
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCSCANFF - Starts playing from the current position in fast
# forward.
#
# input:
#   none
#
# returns:
#   nothing
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCSCANFF
	CDBIOS #MSCSCANFF
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCSCANFR - Same as MSCSCANFF, but backwards.
#
# input:
#   none
#
# returns:
#   nothing
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCSCANFR
	CDBIOS #MSCSCANFR
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_MSCSCANOFF - Returns to normal play mode.  If the drive was
# paused before the scan was initiated, it will be returned to pause.
#
# input:
#   none
#
# returns:
#   nothing
 * -----------------------------------------------------------------------------
 */
.macro BIOS_MSCSCANOFF
	CDBIOS #MSCSCANOFF
.endm


#-----------------------------------------------------------------------
# CD-ROM
#-----------------------------------------------------------------------

/**
 * -----------------------------------------------------------------------------
 * BIOS_ROMREAD - Begins reading data from the CDROM at the designated
# logical sector.  Executes a CDCSTART to begin the read, but doesn't
# stop automatically.
#
# Note - ROMREAD actually pre-seeks by 2 sectors, but doesn't start
# passing data to the CDC until the desired sector is reached.
#
# input:
#   a0.l  address of a 32 bit logical sector number
#
# returns:
#   nothing
#----------------------------------------------------------------------*/
.macro BIOS_ROMREAD
	CDBIOS #ROMREAD
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_ROMREADN - Same as ROMREAD, but stops after reading the requested
# number of sectors.
#
# input:
#   a0.l  address of a 32 bit sector number and 32 bit sector count
#           dc.l    0x00000001   # First sector to read
#           dc.l    0x00001234   # Number of sectors to read
#
# returns:
#   nothing
#----------------------------------------------------------------------*/
.macro BIOS_ROMREADN
	CDBIOS #ROMREADN
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_ROMREADE - Same as ROMREAD, but reads between two logical sectors.
#
# input:
#   a0.l  address of table of 32 bit logical sector numbers
#           dc.l    0x00000001   # First sector to read
#           dc.l    0x00000123   # Last sector to read
#
# returns:
#   nothing
#----------------------------------------------------------------------*/
.macro BIOS_ROMREADE
	CDBIOS #ROMREADE
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_ROMSEEK - Seeks to the designated logical sector and pauses.
#
# input:
#   a0.l  address of a 32 bit logical sector number
#
# returns:
#   nothing
#-----------------------------------------------------------------------
*/
.macro BIOS_ROMSEEK
	CDBIOS #ROMSEEK
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_ROMPAUSEON - Stops reading data into the CDC and pauses.
#
# input:
#   none
#
# returns:
#   nothing
#-----------------------------------------------------------------------
*/
.macro BIOS_ROMPAUSEON
	CDBIOS #ROMPAUSEON
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_ROMPAUSEOFF - Resumes reading data into the CDC from the current
# logical sector.
#
# input:
#   none
#
# returns:
#   nothing
#-----------------------------------------------------------------------
*/
.macro BIOS_ROMPAUSEOFF
	CDBIOS #ROMPAUSEOFF
.endm

#--------------------------------------------------------
# MISC BIOS FUNCTIONS
#-----------------------------------------------------------------------

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDBCHK - Querys the BIOS on the status of the last command.
# Returns success if the command has been executed, not if it's complete.
# This means that CDBCHK will return success on a seek command once the
# seek has started, NOT when the seek is actually finished.
#
# input:
#   none
#
# returns:
#   cc  Command has been executed
#   cs  BIOS is busy
#-----------------------------------------------------------------------
*/
.macro BIOS_CDBCHK
	CDBIOS #CDBCHK
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDBSTAT
#
# input:
#   none
#
# returns:
#   a0.l  address of BIOS status table
#-----------------------------------------------------------------------
*/
.macro BIOS_CDBSTAT
	CDBIOS #CDBSTAT
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDBTOCREAD - Gets the time for the specified track from the TOC.
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
#-----------------------------------------------------------------------
*/
.macro BIOS_CDBTOCREAD
	CDBIOS #CDBTOCREAD
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDBTOCWRITE - Writes data to the TOC in memory.  Don't write to
# the TOC while the BIOS is performing a DRVINIT.
#
# input:
#   a0.l  address of a table of TOC entries to write to the TOC.  Format
#         of the entries is mm:ss:ff:## where ## is the track number.
#
# returns:
#   nothing
#----------------------------------------------------------------------*/
.macro BIOS_CDBTOCWRITE
	CDBIOS #CDBTOCWRITE
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDBPAUSE - Sets the delay time before the BIOS switches from
# pause to standby.  Normal ranges for this delay time are 0x1194 - 0xFFFE.
# A delay of 0xFFFF prevents the drive from stopping, but can  damage the
# drive if used improperly.
#
# input:
#   d1.w  16 bit delay time
#
# returns:
#   nothing
#----------------------------------------------------------------------*/
.macro BIOS_CDBPAUSE
	CDBIOS #CDBPAUSE
.endm


#-----------------------------------------------------------------------
# FADER
#-----------------------------------------------------------------------

/**
 * -----------------------------------------------------------------------------
 * BIOS_FDRSET - Sets the audio volume.  If bit 15 of the volume parameter
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
#----------------------------------------------------------------------*/
.macro BIOS_FDRSET
	CDBIOS #FDRSET
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_FDRCHG - Ramps the audio volume from its current level to a new
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
#----------------------------------------------------------------------*/
.macro BIOS_FDRCHG
	CDBIOS #FDRCHG
.endm


#-----------------------------------------------------------------------
# CDC
#-----------------------------------------------------------------------

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDCSTART - Starts reading data from the current logical sector
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
#----------------------------------------------------------------------*/
.macro BIOS_CDCSTART
	CDBIOS #CDCSTART
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDCSTOP - Stops reading data into the CDC.  If a sector is being
# read when CDCSTOP is called, it's lost.
#
# input:
#   none
#
# returns:
#   nothing
#----------------------------------------------------------------------*/
.macro BIOS_CDCSTOP
	CDBIOS #CDCSTOP
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDCSTAT - Queries the CDC buffer.  If no sector is ready for
# read, the carry bit will be set.  Up to 5 sectors can be buffered in
# the CDC buffer.
#
# input:
#   none
#
# returns:
#   cc  Sector available for read
#   cs  No sectors available
#----------------------------------------------------------------------*/
.macro BIOS_CDCSTAT
	CDBIOS #CDCSTAT
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDCREAD - If a sector is ready in the CDC buffer, the BIOS
# prepares to send the sector to the current device destination.  Make
# sure to set the device destination BEFORE calling CDCREAD.  If a
# sector is ready, the carry bit will be cleared on return and it's
# necessary to respond with a call to CDCACK.
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
#----------------------------------------------------------------------*/
.macro BIOS_CDCREAD
	CDBIOS #CDCREAD
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDCTRN - Uses the Sub-CPU to read one sector into RAM.  The
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
#----------------------------------------------------------------------*/
.macro BIOS_CDCTRN
	CDBIOS #CDCTRN
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_CDCACK - Informs the CDC that the current sector has been read
# and the caller is ready for the next sector.
#
# input:
#   none
#
# returns:
#   nothing
#----------------------------------------------------------------------*/
.macro BIOS_CDCACK
	CDBIOS #CDCACK
.endm


/**
 * -----------------------------------------------------------------------------
 * BIOS_CDCSETMODE - Tells the BIOS which mode to read the CD in.  Accepts
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
#----------------------------------------------------------------------*/
.macro BIOS_CDCSETMODE
	CDBIOS #CDCSETMODE
.endm


#-----------------------------------------------------------------------
# SUBCODES
#-----------------------------------------------------------------------

/**
 * -----------------------------------------------------------------------------
 * BIOS_SCDINIT - Initializes the BIOS for subcode reads.
#
# input:
#   a0.l  address of scratch buffer (at least 0x750 long)
#
# returns:
#   nothing
#----------------------------------------------------------------------*/
.macro BIOS_SCDINIT
	CDBIOS #SCDINIT
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_SCDSTART - Enables reading of subcode data by the CDC.
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
#----------------------------------------------------------------------*/
.macro BIOS_SCDSTART
	CDBIOS #SCDSTART
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_SCDSTOP - Disables reading of subcode data by the CDC.
#
# input:
#   none
#
# returns:
#   nothing
#----------------------------------------------------------------------*/
.macro BIOS_SCDSTOP
	CDBIOS #SCDSTOP
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_SCDSTAT - Checks subcode error status.
#
# input:
#   none
#
# returns:
#   d0.l  errqcodecrc / errpackcirc / scdflag / restrcnt
#   d1.l  erroverrun / errpacketbufful / errqcodefufful / errpackfufful
#----------------------------------------------------------------------*/
.macro BIOS_SCDSTAT
	CDBIOS #SCDSTAT
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_SCDREAD - Reads R through W subcode channels.
#
# input:
#   a0.l  address of subcode buffer (24 bytes minimum)
#
# returns:
#   cc    Read successful
#   cs    Read failed
#   a0.l  address of next subcode buffer (a0.l + 24)
#----------------------------------------------------------------------*/
.macro BIOS_SCDREAD
	CDBIOS #SCDREAD
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_SCDPQ - Gets P & Q codes from subcode.
#
# input:
#   a0.l  address of Q code buffer (12 bytes minimum)
#
# returns:
#   cc    Read successful
#   cs    Read failed
#   a0.l  address of next Q code buffer (a0.l + 12)
#----------------------------------------------------------------------*/
.macro BIOS_SCDPQ
	CDBIOS #SCDPQ
.endm

/**
 * -----------------------------------------------------------------------------
 * BIOS_SCDPQL - Gets the last P & Q codes.
#
# input:
#   a0.l  address of Q code buffer (12 bytes minimum)
#
# returns:
#   cc    Read successful
#   cs    Read failed
#   a0.l  address of next Q code buffer (a0.l + 12)
#----------------------------------------------------------------------*/
.macro BIOS_SCDPQL
	CDBIOS #SCDPQL
.endm


#-----------------------------------------------------------------------
# FRONT PANEL LEDS
#-----------------------------------------------------------------------

.equ	LEDREADY,		0
.equ	LEDDISCIN,	1
.equ	LEDACCESS,	2
.equ	LEDSTANDBY,	3
.equ	LEDERROR,		4
.equ	LEDMODE5,		5
.equ	LEDMODE6,		6
.equ	LEDMODE7,		7

/**
 * -----------------------------------------------------------------------------
 * BIOS_LEDSET - Controls the Ready and Access LED's on the front panel
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
#----------------------------------------------------------------------*/
.macro BIOS_LEDSET
	CDBIOS #LEDSET
.endm
