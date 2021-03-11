/**
 * \file cd_main.h
 * Gate Array (GA) and BIOS function entry definitions
 * for the Main CPU side
 */

#ifndef MEGADEV__CD_GA_MAIN_H
#define MEGADEV__CD_GA_MAIN_H

#include "types.h"
#include "cd_main_def.h"

#define GA_COMFLAGS_MAIN_C (*(volatile u8*)GA_COMFLAGS)
#define GA_COMFLAGS_SUB_C (*(volatile const u8*)GA_COMFLAGS+1)

#define GA_COMCMD0_C (*(volatile u16*)GA_COMCMD0)
#define GA_COMCMD1_C (*(volatile u16*)GA_COMCMD1)
#define GA_COMCMD2_C (*(volatile u16*)GA_COMCMD2)
#define GA_COMCMD3_C (*(volatile u16*)GA_COMCMD3)
#define GA_COMCMD4_C (*(volatile u16*)GA_COMCMD4)
#define GA_COMCMD5_C (*(volatile u16*)GA_COMCMD5)
#define GA_COMCMD6_C (*(volatile u16*)GA_COMCMD6)
#define GA_COMCMD7_C (*(volatile u16*)GA_COMCMD7)

#define GA_COMSTAT0_C (*(volatile const u16*)GA_COMSTAT0)
#define GA_COMSTAT1_C (*(volatile const u16*)GA_COMSTAT1)
#define GA_COMSTAT2_C (*(volatile const u16*)GA_COMSTAT2)
#define GA_COMSTAT3_C (*(volatile const u16*)GA_COMSTAT3)
#define GA_COMSTAT4_C (*(volatile const u16*)GA_COMSTAT4)
#define GA_COMSTAT5_C (*(volatile const u16*)GA_COMSTAT5)
#define GA_COMSTAT6_C (*(volatile const u16*)GA_COMSTAT6)
#define GA_COMSTAT7_C (*(volatile const u16*)GA_COMSTAT7)

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
