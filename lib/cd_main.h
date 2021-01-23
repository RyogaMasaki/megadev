/**
 * \file cd_main.h
 * Gate Array (GA) and BIOS function entry definitions
 * for the Main CPU side
 */

#ifndef MEGADEV__CD_GA_MAIN_H
#define MEGADEV__CD_GA_MAIN_H

#include "types.h"
#include "cd_main_def.h"

/**
 * Wait for Main CPU access to 2M Word RAM
 */
inline void wait_2m() {
	asm(R"(
1:btst %0, %p1
  beq 1b
)"::"i"(MEMORYMODE_RET_BIT),"i"(GA_MEMORYMODE+1));
}

/**
 * Grant 2M Word RAM access to the Sub CPU and wait for confirmation
 */
inline void grant_2m() {
	asm(R"(
1:bset #1, %p0
  btst #1, %p0
	beq 1b
)"::"i"(GA_MEMORYMODE+1));
}

/**
 * Clears the Main comm registers (COMCMD) and flags
 */
inline void clear_comm_regs() {
	asm(R"(
  lea %p0, a0
  moveq #0, d0
  move.b d0, -2(a0) /* upper byte of comm flags */
  move.l d0, (a0)+
  move.l d0, (a0)+
  move.l d0, (a0)+
  move.l d0, (a0)+
)"::"i"(GA_COMCMD0) : "d0", "a0");
}


#endif
