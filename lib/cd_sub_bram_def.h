/**
 * \file cd_sub_bram_def.h
 * Internal Backup RAM (BRAM) defines
 */

#ifndef MEGADEV__CD_SUB_BRAM_DEF_H
#define MEGADEV__CD_SUB_BRAM_DEF_H

#define _BURAM			0x00005F16

/*
	Backup RAM (BRAM) bios call codes
*/
#define BRMINIT    0x0000
#define BRMSTAT    0x0001
#define BRMSERCH   0x0002
#define BRMREAD    0x0003
#define BRMWRITE   0x0004
#define BRMDEL     0x0005
#define BRMFORMAT  0x0006
#define BRMDIR     0x0007
#define BRMVERIFY  0x0008


#endif
