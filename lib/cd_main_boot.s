/**
 * \file cd_main_boot.s
 * Boot ROM (Main CPU) system calls
 */

#ifndef MEGADEV__CD_MAIN_BOOT_S
#define MEGADEV__CD_MAIN_BOOT_S

#include "cd_main_boot_def.h"
#include "macros.s"

.macro UPDATE_INPUTS
  jsr _UPDATE_INPUT
.endm

.macro DECMP_VRAM
  jsr _DECMP_VRAM
.endm

#endif
