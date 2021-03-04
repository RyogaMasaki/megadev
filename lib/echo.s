/**
 * \file echo.s
 * \brief Echo sound driver control
 * 
 * Converted for use with GAS
 */

#ifndef MEGADEV__ECHO_S
#define MEGADEV__ECHO_S

#include "macros.s"
#include "z80_def.h"

.section .text

/**
 * \fn echo_init
 * \brief Initialize driver with default settings and load instrument list
 * \param[in] A0.l Pointer to instrument list
 */
FUNC echo_init
    movem.l d0-d1, -(sp)

    Z80_DO_RESET
    Z80_DO_BUSREQ

    move.b  #0x01, (0xA01FFF)         // Command: load pointer list
    move.b  #0x00, (0xA01FFB)         // No other command yet

    move.l  a0, d0                  // Easier to manipulate here
    move.b  d0, (0xA01FFD)           // Store low address byte
    lsr.l   #7, d0                  // Get high address byte
    lsr.b   #1, d0                    // We skip one bit
    bset.l  #7, d0                    // Point into bank window
    move.b  d0, (0xA01FFE)           // Store high address byte
    lsr.w   #8, d0                  // Get bank byte
    move.w  d0, d1                    // Parse 32X bit separately
    lsr.w   #1, d1                    // Put 32X bit in place
    and.b   #0x7F, d0                  // Filter out unused bit from addresses
    and.b   #0x80, d1                  // Filter out all but 32X bit
    or.b    d1, d0                    // Put everything together
    move.b  d0, (0xA01FFC)           // Store bank byte

    moveq   #0, d0                  // Set default global volumes
    lea     (0xA01FE0), a0
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  #1, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (a0)+
    move.b  d0, (0xA01FF1)

    move.b  #0xFF, (0xA01F00)         // No direct events to execute
    move.b  #0x00, (0xA01F80)

    Z80_DO_RESET
    Z80_DO_BUSRELEASE

    movem.l (sp)+, d0-d1
    rts

FUNC echo_convert_inst_list
    movem.l d0-d1/a1, -(sp)
    move.l     a0,a1
1:  move.l  (a0)+, d0                  // Easier to manipulate here
    beq 2f
    move.b  d0, 1(a1)        // Store low address byte
    lsr.l   #7, d0                  // Get high address byte
    lsr.b   #1, d0                    // We skip one bit
    bset.l  #7, d0                    // Point into bank window
    move.b  d0, (a1)          // Store high address byte
    lsr.w   #8, d0                  // Get bank byte
    move.w  d0, d1                    // Parse 32X bit separately
    lsr.w   #1, d1                    // Put 32X bit in place
    and.b   #0x7F, d0                  // Filter out unused bit from addresses
    and.b   #0x80, d1                  // Filter out all but 32X bit
    or.b    d1, d0                    // Put everything together
    move.b  d0, 2(a1)        // Store bank byte
    adda    #3, a1
    bra 1b
2:  move.b  #0, (a1)
    movem.l (sp)+, d0-d1/a1
    rts

/**
 * \fn Echo_SendCommand
 * \brief Send command to Echo driver
 * \param[in] D0.b Command
 */
FUNC Echo_SendCommand
    movem.l d1/a1, -(sp)            // Save registers
1:  Z80_DO_BUSREQ                 // We need the Z80 bus

    lea     (0xA01FFF), a1           // First try the 1st slot
    tst.b   (a1)                    // Is 1st slot available?
    beq.s   3f                    // If so, move on
    subq.l  #4, a1                  // Try 2nd slot otherwise

    tst.b   (a1)                    // Check if 2nd slot is ready
    beq.s   3f                  // Too busy?
    Z80_DO_BUSRELEASE                   // Let Echo continue
2:  move.w  #0x1FF, d1                 // Give it some time
    dbf     d1, 2b                       // ...
    bra.s   1b                      // Try again

3:  move.b  d0, (a1)                // Write command ID
    Z80_DO_BUSRELEASE                 // We're done with the Z80 bus

    movem.l (sp)+, d1/a1            // Restore registers
    rts                             // End of subroutine

/**
 * \fn Echo_SendCommandEx
 * \brief Send a command to Echo driver with address parameter
 * \param[in] D0.b Command
 * \param[in] A0.l Address
 */
FUNC Echo_SendCommandEx
    movem.l d0-d1/a1, -(sp)         // Save registers
1:  Z80_DO_BUSREQ                 // We need the Z80 bus

    lea     (0xA01FFF), a1           // First try the 1st slot
    tst.b   (a1)                    // Is 1st slot available?
    beq.s   3f                    // If so, move on
    subq.l  #4, a1                  // Try 2nd slot otherwise

    tst.b   (a1)                    // Check if 2nd slot is ready
    beq.s   3f                  // Too busy?
    Z80_DO_BUSRELEASE                   // Let Echo continue
2:  move.w  #0xFF, d1                 // Give it some time
    dbf     d1, 2b                       // ...
    bra.s   1b                      // Try again

3:  move.b  d0, (a1)                // Write command ID

    move.l  a0, d0                  // Easier to manipulate here
    move.b  d0, -2(a1)              // Store low address byte
    lsr.l   #7, d0                  // Get high address byte
    lsr.b   #1, d0                    // We skip one bit
    bset.l  #7, d0                    // Point into bank window
    move.b  d0, -1(a1)              // Store high address byte

    lsr.w   #8, d0                  // Get bank byte
    move.w  d0, d1                    // Parse 32X bit separately
    lsr.w   #1, d1                    // Put 32X bit in place
    and.b   #0x7F, d0                  // Filter out unused bit from addresses
    and.b   #0x80, d1                  // Filter out all but 32X bit
    or.b    d1, d0                    // Put everything together
    move.b  d0, -3(a1)              // Store bank byte

    Z80_DO_BUSRELEASE                 // We're done with the Z80 bus

    movem.l (sp)+, d0-d1/a1         // Restore registers
    rts                             // End of subroutine

/**
 * \fn Echo_SendCommandEx
 * \brief Send a command to Echo driver with byte parameter
 * \param[in] D0.b Command
 * \param[in] D1.b Parameter
 */
FUNC Echo_SendCommandByte
    movem.l d1-d2/a1, -(sp)         // Save registers

1:  Z80_DO_BUSREQ                 // We need the Z80 bus

    lea     (0xA01FFF), a1           // First try the 1st slot
    tst.b   (a1)                    // Is 1st slot available?
    beq.s   3f                    // If so, move on
    subq.l  #4, a1                  // Try 2nd slot otherwise

    tst.b   (a1)                    // Check if 2nd slot is ready
    beq.s   3f                  // Too busy?
    Z80_DO_BUSRELEASE                   // Let Echo continue
2:  move.w  #0xFF, d2                 // Give it some time
    dbf     d2, 2b                       // ...
    bra.s   1b                     // Try again

3:  move.b  d0, (a1)                // Write command ID
    move.b  d1, -3(a1)              // Write parameter
    Z80_DO_BUSRELEASE                 // We're done with the Z80 bus

    movem.l (sp)+, d1-d2/a1         // Restore registers
    rts                             // End of subroutine

/**
 * \fn Echo_PlaySFX
 * \brief Play a sound effect
 * param[in] A0.l Pointer to SFX data
 */
FUNC Echo_PlaySFX
    move.w  d0, -(sp)               // Save register
    move.b  #0x02, d0                // Command 0x02 = play SFX
    bsr     Echo_SendCommandEx    // Send command to Echo
    move.w  (sp)+, d0               // Restore register
    
    rts                             // End of subroutine

/**
 * \fn Echo_StopSFX
 * \brief Stop currently playing sound effect
 */
FUNC Echo_StopSFX
    move.w  d0, -(sp)               // Save register
    move.b  #0x03, d0                // Command 0x03 = stop SFX
    bsr     Echo_SendCommand        // Send command to Echo
    move.w  (sp)+, d0               // Restore register
    
    rts                             // End of subroutine

/**
 * \fn Echo_PlayBGM
 * \brief Play background music
 * \param[in] A0.l Pointer to BGM data
 */
FUNC Echo_PlayBGM
    move.w  d0, -(sp)               // Save register
    move.b  #0x04, d0                // Command 0x04 = play BGM
    bsr     Echo_SendCommandEx    // Send command to Echo
    move.w  (sp)+, d0               // Restore register
    
    rts                             // End of subroutine

/**
 * \fn Echo_StopBGM
 * \brief Stop currently playing background music
 */
FUNC Echo_StopBGM
    move.w  d0, -(sp)               // Save register
    move.b  #0x05, d0                // Command 0x05 = stop BGM
    bsr     Echo_SendCommand        // Send command to Echo
    move.w  (sp)+, d0               // Restore register
    rts                             // End of subroutine

/**
 * \fn Echo_PauseBGM
 * \brief Pause background music playback
 */
FUNC Echo_PauseBGM
    move.w  d0, -(sp)               // Save register
    move.b  #0x08, d0                // Command 0x08 = pause BGM
    bsr     Echo_SendCommand        // Send command to Echo
    move.w  (sp)+, d0               // Restore register
    rts                             // End of subroutine

/**
 * \fn Echo_ResumeBGM
 * \brief Resume background music playback
 */
FUNC Echo_ResumeBGM
    move.w  d0, -(sp)               // Save register
    move.b  #0x06, d0                // Command 0x06 = resume BGM
    bsr     Echo_SendCommand        // Send command to Echo
    move.w  (sp)+, d0               // Restore register
    rts                             // End of subroutine

/**
 * \fn Echo_PlayDirect
 * \brief Injects events into the BGM stream for the next tick.
 * \param[in] A0.l Pointer to stream data
 */
FUNC Echo_PlayDirect
    Z80_DO_BUSREQ              // We need the Z80 bus
    movem.l d0-d1/a0-a2, -(sp)  // Save registers

1:  moveq   #0, d0      // Retrieve direct stream length
    move.b  (0xA01F80), d0
    bpl.s   3f          // Is it valid?

2:  Z80_DO_BUSRELEASE      // If not, let the Z80 run until it's
7:  move.w  #0x1FF, d0  // done processing the direct stream
    dbf     d0, 7b      // ...
    Z80_DO_BUSREQ      // Take over Z80 bus again
    bra.s   1b          // Retry

3:  lea     (0xA01F00), a1    // Get pointer to last event in the
    lea     (a1,d0.w), a1     // direct stream

    lea     ArgTable(pc), a2  // Copy stream into the direct buffer

4:  move.b  (a0)+, d0         // Get byte from source stream...
    move.b  d0, (a1)+         // ...and store it into direct stream
    cmp.b   #0xFF, d0         // Was it the STOP event?
    beq.s   6f                // If so, we're done
    moveq   #0, d0            // Check how many argument bytes it has
    move.b  (a2,d0.w), d0
    subq.w  #1, d0            // Adjust for DBF
    bmi.s   4b                // No arguments?

5:  move.b  (a0)+, (a1)+      // Copy the arguments
    dbf     d0, 5b
    bra.s   4b                // Keep copying

6:  move.w  a1, d0            // Update stream length
    subq.b  #1, d0
    move.b  d0, (0xA01F80)

    movem.l (sp)+, d0-d1/a0-a2  // Restore registers
    Z80_DO_BUSRELEASE              // We're done with the Z80 bus
    rts

/**
 * \brief Look-up table used to know how many bytes each event has as argument
 */
ArgTable:
    .byte    1,1,1,0, 1,1,1,0, 1,1,1,1, 1,0,0,0      // 0x00-0x0F (key on)
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0x10-0x1F (key off)
    .byte    1,1,1,0, 1,1,1,0, 1,1,1,1, 0,0,0,0      // 0x20-0x2F (set volume)
    .byte    2,2,2,0, 2,2,2,0, 2,2,2,1, 0,0,0,0      // 0x30-0x3F (set frequency)
    .byte    1,1,1,0, 1,1,1,0, 1,1,1,1, 0,0,0,0      // 0x40-0x4F (set instrument)
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0x50-0x5F
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0x60-0x6F
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0x70-0x7F
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0x80-0x8F
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0x90-0x9F
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0xA0-0xAF
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0xB0-0xBF
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0xC0-0xCF
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0xD0-0xDF (quick delay)
    .byte    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0      // 0xE0-0xEF (lock channel)
    .byte    1,1,1,0, 1,1,1,0, 2,2,1,1, 0,0,1,0      // 0xF0-0xFF (miscellaneous)

/**
 * \fn Echo_SetPCMRate
 * \brief Sets the playback rate of PCM
 * \param[in] D0.b New rate (timer A value)
 */
FUNC Echo_SetPCMRate
    movem.l d0-d1, -(sp)            // Save registers
    move.b  d0, d1                  // Put parameter in place
    move.b  #0x07, d0                // Command 0x07 = set PCM rate
    bsr     Echo_SendCommandByte    // Send command to Echo
    movem.l (sp)+, d0-d1            // Restore registers
    rts                             // End of subroutine

//****************************************************************************
// Echo_SetStereo
// Sets whether stereo is enabled or not
//
// input d0.b ... 0 to disable, otherwise to enable
//****************************************************************************

/**
 * \fn Echo_SetStereo
 * \brief Enable/disable stereo output
 * \param[in] D0.b Stereo output
 * \n 0: Disable
 * \n 1: Enable
 */
FUNC Echo_SetStereo
    movem.l d0-d1, -(sp)            // Save registers
    tst.b   d0                      // Check what we want to do
    seq.b   d1                      // Put parameter in place
    move.b  #0x09, d0                // Command 0x09 = set stereo
    bsr     Echo_SendCommandByte    // Send command to Echo
    movem.l (sp)+, d0-d1            // Restore registers
    rts                             // End of subroutine

/**
 * \fn Echo_SetVolume
 * \brief Changes the global volume for every channel
 * \param[in] D0.b New volume
 * \n (0: quiet, 255: loud)
 */
FUNC Echo_SetVolume
    Z80_DO_BUSREQ                 // We need the Z80 bus
    movem.l d0-d1/a0-a1, -(sp)      // Save registers
    
    lea     Echo_FMVolTable(pc), a0 // Determine FM volume
    moveq   #0, d1
    move.b  d0, d1
    lsr.b   #2, d1
    move.b  (a0,d1.w), d1
    
    lea     (0xA01FE0), a1           // Copy new FM volume values
    move.b  d1, (a1)+                 // FM channel 0
    move.b  d1, (a1)+                 // FM channel 1
    move.b  d1, (a1)+                 // FM channel 2
    move.b  d1, (a1)+                 // FM channel 3
    move.b  d1, (a1)+                 // FM channel 4
    move.b  d1, (a1)+                 // FM channel 5
    move.b  d1, (a1)+                 // FM channel 6
    move.b  d1, (a1)+                 // FM channel 7
    
    lea     Echo_PSGVolTable(pc),a0 // Determine PSG volume
    moveq   #0, d1
    move.b  d0, d1
    lsr.b   #2, d1
    move.b  (a0,d1.w), d1
    
                                    // Copy new PSG values
    move.b  d1, (a1)+                 // PSG channel 0
    move.b  d1, (a1)+                 // PSG channel 1
    move.b  d1, (a1)+                 // PSG channel 2
    move.b  d1, (a1)+                 // PSG channel 3
    
    cmp.b   #0x40, d0                // Determine whether PCM should be enabled
    scc     d1
    //shs     d1                        // (we do an heuristic for enabling PCM
    and.b   #1, d1                    // based on the volume value)
    move.b  d1, (a1)+
    
    move.b  #1, (0xA01FF1)           // Tell Echo to update the volume levels
    
    movem.l (sp)+, d0-d1/a0-a1      // Restore registers
    Z80_DO_BUSRELEASE                 // We're done with the Z80 bus
    rts                             // End of subroutine


Echo_FMVolTable:
    .byte    0x7F,0x7B,0x77,0x73,0x70,0x6C,0x68,0x65,0x61,0x5E,0x5A,0x57,0x54,0x50,0x4D,0x4A
    .byte    0x47,0x44,0x41,0x3F,0x3C,0x39,0x36,0x34,0x31,0x2F,0x2D,0x2A,0x28,0x26,0x24,0x22
    .byte    0x20,0x1E,0x1C,0x1A,0x18,0x16,0x15,0x13,0x12,0x10,0x0F,0x0D,0x0C,0x0B,0x0A,0x09
    .byte    0x08,0x07,0x06,0x05,0x04,0x04,0x03,0x02,0x02,0x01,0x01,0x01,0x00,0x00,0x00,0x00

Echo_PSGVolTable:
    .byte    0x0F,0x0F,0x0E,0x0E,0x0D,0x0D,0x0C,0x0C,0x0B,0x0B,0x0B,0x0A,0x0A,0x0A,0x09,0x09
    .byte    0x08,0x08,0x08,0x07,0x07,0x07,0x06,0x06,0x06,0x06,0x05,0x05,0x05,0x04,0x04,0x04
    .byte    0x04,0x03,0x03,0x03,0x03,0x03,0x02,0x02,0x02,0x02,0x02,0x02,0x01,0x01,0x01,0x01
    .byte    0x01,0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

/**
 * \fn Echo_SetVolumeEx
 * \brief Change volume for individual channels
 * \param[in] A0.l Pointer to volume structure
 * \details The volume structure is defined like so:
 *   8 bytes of FM channel volumes (0 to 127)
 *   4 bytes of PSG channel volumes (0 to 15)
 *   1 byte with PCM toggle (0 or 1)
 *   3 reserved (currently unused)
 */
FUNC Echo_SetVolumeEx
    Z80_DO_BUSREQ                 // We need the Z80 bus
    movem.l a0-a1, -(sp)            // Save registers
    
    lea     (0xA01FE0), a1           // Copy new volume values
    move.b  (a0)+, (a1)+              // FM channel 0
    move.b  (a0)+, (a1)+              // FM channel 1
    move.b  (a0)+, (a1)+              // FM channel 2
    move.b  (a0)+, (a1)+              // FM channel 3
    move.b  (a0)+, (a1)+              // FM channel 4
    move.b  (a0)+, (a1)+              // FM channel 5
    move.b  (a0)+, (a1)+              // FM channel 6
    move.b  (a0)+, (a1)+              // FM channel 7
    move.b  (a0)+, (a1)+              // PSG channel 0
    move.b  (a0)+, (a1)+              // PSG channel 1
    move.b  (a0)+, (a1)+              // PSG channel 2
    move.b  (a0)+, (a1)+              // PSG channel 3
    move.b  (a0)+, (a1)+              // PCM channel toggle
    move.b  (a0)+, (a1)+              // (reserved)
    move.b  (a0)+, (a1)+              // (reserved)
    move.b  (a0)+, (a1)+              // (reserved)
    
    move.b  #1, (0xA01FF1)           // Tell Echo to update the volume levels
    
    movem.l (sp)+, a0-a1            // Restore registers
    Z80_DO_BUSRELEASE                 // We're done with the Z80 bus
    rts                             // End of subroutine

/**
 * \fn Echo_GetStatus
 * \brief Get the current status of the Echo driver
 * \param[out] D0.w Status
 * \n Bit 0: SFX playing
 * \n Bit 1: BGM playing
 * \n Bit 14: Direct events not played
 * \n Bit 15: Command not yet parsed
 */
FUNC Echo_GetStatus
    movem.l d1-d2/a1, -(sp)         // Save registers

    clr.w   d0                      // Set all needed bits to 0
    Z80_DO_BUSREQ                 // We need the Z80 bus
    move.b  (0xA01FF0), d0           // Get the status flags

    tst.b   (0xA01FFB)               // Check if any commands can be sent
    beq.s   1f                // Any room left for new commands?
    bset.l  #15, d0                 // If not, set the relevant flag

1:  cmpi.b  #0xFF, (0xA01F00)         // Check if the direct buffer is empty
    beq.s   2f            // Any direct events still to be played?
    bset.l  #14, d0                 // If so, set the relevant flag

2:  cmpi.b  #0xC9, (0xA00008)         // Check if ch6 is in FM or PCM mode
    beq.s   3f                 // PCM playback active? (i.e. not RET)
    bset.l  #13, d0                 // If so, set the relevant flag

3:  moveq   #0, d1                  // Clear unused bits from index
    lea     AndTable(pc), a1       // Get pointer to look-up tables
    
    move.b  (0xA01FFF), d1           // Get next pending command (if any)
    beq.s   4f           // No commands left to process?
    move.b  (a1,d1.w), d2           // Get mask of flags to leave
    and.b   d2, d0                  // Remove flags that should be clear
    move.b  OrTable-AndTable(a1,d1.w), d2 // Get mask of flags to set
    or.b    d2, d0                  // Insert flags that should be set

    move.b  (0xA01FFB), d1           // Repeat that with 2nd pending command
    beq.s   4f
    move.b  (a1,d1.w), d2
    and.b   d2, d0
    move.b  OrTable-AndTable(a1,d1.w), d2
    or.b    d2, d0

4:  Z80_DO_BUSRELEASE                 // Let the Z80 go!
    movem.l (sp)+, d1-d2/a1         // Restore registers
    rts                             // End of subroutine

//----------------------------------------------------------------------------
// Look-up tables used to readjust the status flags based on pending commands
// that haven't been processed yet (normally they wouldn't be updated yet, but
// this can catch programmers off guard so we cheat it).
//
// Every byte represents a possible command.
//----------------------------------------------------------------------------

AndTable:  .byte 0xFF,0xFF, 0xFF,0xFE,0xFF,0xFD, 0xFF,0xFF,0xFF
OrTable:   .byte 0x00,0x00, 0x01,0x00,0x02,0x00, 0x00,0x00,0x00
.align 2

//****************************************************************************
// Echo_GetFlags
// Gets the current values of the flags.
//
// output d0.b ... Bitmask with flags
//****************************************************************************

FUNC Echo_GetFlags
    Z80_DO_BUSREQ                 // Request Z80 bus
    move.b  (0xA01FF2), d0           // Get the flags
    Z80_DO_BUSRELEASE                 // Done with Z80 RAM
    rts                             // End of subroutine

//****************************************************************************
// Echo_SetFlags
// Sets flags from the 68000.
//
// input d0.b ... Bitmask of flags to be set (1 = set, 0 = intact)
//****************************************************************************

FUNC Echo_SetFlags
    subq.w  #4, sp                  // Buffer for the events
    move.b  #0xFA, (sp)                // Set flags
    move.b  d0, 1(sp)                 // <bitmask>
    move.b  #0xFF, 2(sp)               // End of stream
    
    move.l  a0, -(sp)               // Issue the events
    lea     4(sp), a0
    bsr     Echo_PlayDirect
    move.l  (sp)+, a0
    
    addq.w  #4, sp                  // Done with the buffer
    rts                             // End of subroutine

//****************************************************************************
// Echo_ClearFlags
// Clear flags from the 68000.
//
// input d0.b ... Bitmask of flags to be cleared (1 = clear, 0 = intact)
//****************************************************************************

FUNC Echo_ClearFlags
    not.b   d0                      // Bitmask is inverted
    subq.w  #4, sp                  // Buffer for the events
    move.b  #0xFB, (sp)                // Set flags
    move.b  d0, 1(sp)                 // <bitmask>
    move.b  #0xFF, 2(sp)               // End of stream
    not.b   d0                      // Restore register
    
    move.l  a0, -(sp)               // Issue the events
    lea     4(sp), a0
    bsr     Echo_PlayDirect
    move.l  (sp)+, a0
    
    addq.w  #4, sp                  // Done with the buffer
    rts                             // End of subroutine

#endif
