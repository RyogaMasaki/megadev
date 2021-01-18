/**
 * \file cd_sub.s
 * Sub CPU Gate Array and misc. utilities
 */

#ifndef MEGADEV__CD_SUB_S
#define MEGADEV__CD_SUB_S

#include "cd_sub_def.h"

/**
 * CLEAR_COMM_REGS
 * Clears the Sub comm registers (COMSTAT) and flags
 * BREAK: d0, a0
 */
.macro CLEAR_COMM_REGS
  lea GA_COMSTAT0, a0
  moveq #0, d0
  move.b d0, -0x11(a0) // lower byte of comm flags
  move.l d0, (a0)+
  move.l d0, (a0)+
  move.l d0, (a0)+
  move.l d0, (a0)+
.endm

/**
 * WAIT_2M
 * Wait for Sub CPU access to 2M Word RAM
 */
.altmacro
.macro WAIT_2M
LOCAL loop

loop:
  btst #MEMORYMODE_DMNA_BIT, GA_MEMORYMODE+1
  beq loop
.endm

/**
 * GRANT_2M
 * Grant 2M Word RAM access to the Main CPU and wait for confirmation
 */
.altmacro
.macro GRANT_2M
LOCAL loop

loop:
  bset #MEMORYMODE_RET_BIT, GA_MEMORYMODE+1
  btst #MEMORYMODE_RET_BIT, GA_MEMORYMODE+1
  beq loop
.endm

#endif
