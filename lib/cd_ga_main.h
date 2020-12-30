/**
 * \file cd_ga_main.h
 * Mega CD GA (Main side) functions
 */

#ifndef MEGADEV__CD_GA_MAIN_H
#define MEGADEV__CD_GA_MAIN_H

#include "types.h"
#include "cd_ga_main_def.h"

/**
 * Waits for access to Word RAM (2M Mode) from the Sub CPU
 */
extern inline void wait_2m();

/**
 * Grants access to Word RAM (2M Mode) to the Sub CPU
 */
extern inline void grant_2m();

#endif
