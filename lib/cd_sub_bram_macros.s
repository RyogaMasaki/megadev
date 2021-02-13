/**
 * \file cd_sub_bram_macros.s
 * Internal Backup RAM (BRAM)
 */

#ifndef MEGADEV__CD_SUB_BRAM_S
#define MEGADEV__CD_SUB_BRAM_S

#include "macros.s"
#include "cd_sub_bios_def.h"

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

.macro BIOS_BRMINIT
	BURAM #BRMINIT
.endm

.macro BIOS_BRMSTAT
	BURAM #BRMSTAT
.endm

.macro BIOS_BRMSERCH
	BURAM #BRMSERCH
.endm

.macro BIOS_BRMREAD
	BURAM #BRMREAD
.endm

.macro BIOS_BRMWRITE
	BURAM #BRMWRITE
.endm

.macro BIOS_BRMDEL
	BURAM #BRMDEL
.endm

.macro BIOS_BRMFORMAT
	BURAM #BRMFORMAT
.endm

.macro BIOS_BRMDIR
	BURAM #BRMDIR
.endm

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
