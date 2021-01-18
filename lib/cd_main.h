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
extern inline void wait_2m();

/**
 * Grant 2M Word RAM access to the Sub CPU and wait for confirmation
 */
extern inline void grant_2m();

/**
 * Clears the Main comm registers (COMCMD) and flags
 */
extern inline void clear_comm_regs();


#endif
