/**
 * \file cd_main_boot_def.h
 * Boot ROM (Main CPU) system call definitions
 */

#ifndef MEGADEV__CD_MAIN_BOOT_DEF_H
#define MEGADEV__CD_MAIN_BOOT_DEF_H

/**
 * The following are memory locations used by the Boot ROM subroutines
 * There is some conflicting information on whether these should be used as
 * the manuals say that memory above 0xfffd00 should not be used. However,
 * some of these locations are necessary in order to use the Boot ROM
 * subroutines. This has not yet been thoroughly tested across different
 * BIOS revisions.
 */

/**
 * Sprite list RAM cache
 * Size: 0x280
 */
#define _SPRITE_LIST      0xfff900

/**
 * CRAM (palette) RAM cache 
 * Size: 0x80
 */
#define _PALETTE 0xfffb80

/**
 * RAM cache of all VDP registers (except DMA regs), making up 19 entries. 
 * You will need to keep these updated manually unless you use _VDP_REG_LOAD.
 */
#define _VDP_REGS  0xfffdb4

/**
 * Cached value of the plane width as defined in VDP reg. 0x10. 
 * This needs to be manually updated each time the register is changed!!
 */
#define PLANE_WIDTH   0xFFFE2E

/**
 * This is used by the Boot ROM VINT/VINT_WAIT routines for graphics updates
 * during vblank.
 * Size: 8bit
 * 
 * Bit 0 - Copy sprite list to VDP
 * Bit 1 - Call VINT_EX vector during vblank
 */
/* 8 bit */
#define _VINT_FLAGS    0xfffe26

/* _VINT_FLAGS bits/masks */
#define COPY_SPRLIST_BIT  0
#define CALL_VINT_EX_BIT  1

#define COPY_SPRLIST_MSK  1 << COPY_SPRLIST_BIT
#define CALL_VINT_EX_MSK  1 << CALL_VINT_EX_BIT

/* 8 bit */
#define _GFX_REFRESH 0xfffe29

/* _GFX_UPD_FLAGS bits/masks */
#define CRAM_UPDATE_BIT 0

#define CRAM_UPDATE_MSK 1 << CRAM_UPDATE_BIT

/**
 * Skips extended operations during vblank - CRAM copy, sprite list copy,
 * increase vblank counter
 * Will still perform IO updates, though
 * Size: 8bit
 */
/* 8bit */
#define VBLANK_SKIP_GFX_UPDATE 0xfffe28

/*16 bit*/
#define _INPUT_P1 0xfffe20
/* 8 bit */
#define _INPUT_P1_HOLD 0xfffe20
#define _INPUT_P1_PRESS 0xfffe21

/*16 bit*/
#define _INPUT_P2 0xfffe22
/* 8 bit */
#define _INPUT_P2_HOLD 0xfffe22
#define _INPUT_P2_PRESS 0xfffe23

/* function entry */
/**
 * _RESET
 * This is used as the default reset vector. Leads to Mega CD title screen.
 */
#define _RESET         0x000280

/**
 * _ENTRY
 * This is the Boot ROM entry. On cold boot, checks for TMSS, clears RAM, writes
 * Z80 driver, writes PSG data, then moves on to checking hardware region and
 * clearing VRAM. On warm boot, skips directly to region check, then jumps to
 * the reset vector. Leads to Mega CD title screen.
 */
#define _ENTRY         0x000284

/**
 * Sets default VDP regs, clears VRAM, sets default vectors, inits controllers,
 * loads Z80 data, transfers Sub CPU BIOS, loads CD player program
 */
#define _INIT          0x000288

/**
 * Same as above, but sets the stack pointer first.
 */
#define _INIT_SET_SP   0x00028C

/**
 * Vertical Blank interrupt handler. Copies GA comm registers to the RAM
 * mirrors, sends INT2 (VINT ocurred) to Sub CPU, updates VDP palette from
 * RAM, calls VINT_EX, updates IO (controllers).
 */
#define _VINT          0x000290

/**
 * Sets the HINT vector. Sets the GA_HINTVECT register to 0xFD0C
 * IN:
 *  a1 - new HINT vector
 */
#define _SET_HINT      0x000294

/**
 * Reads values from the P1/P2 controllers and stores them in RAM
 * BREAK:
 *  d6-d7/a5-a6
 */
#define _UPDATE_INPUT  0x000298

#define _UNKNOWN07     0x00029C


#define _VDP_CLR_RAM   0x0002A0
#define _VDP_CLR_LISTS 0x0002A4
#define _VDP_CLR_VSRAM 0x0002A8
#define _VDP_REG_INIT  0x0002AC

/**
 * Load values into multiple VDP registers
 * IN:
 *  a1 - Pointer to register data
 *       Data should consist of word sized values,
 *       where the upper byte is the register ID
 *       (e.g. 80, 81, etc) and the lower byte is
 *       the value. Each value will be stored in RAM
 *       in VDP_REG_CACH.
 */
#define _VDP_REG_LOAD  0x0002B0

#define _VDP_FILL      0x0002B4
#define _VDP_LOAD_MAP  0x0002C4
#define _VDP_LOAD_MAP2 0x0002C8
#define _VDP_LOAD_MAP4 0x0002CC

/**
 * Enable VDP display.
 * (Sets bit 6 on VDP reg. #1)
 */
#define _VDP_DISP_ENAB 0x0002D8

/**
 * Disable VDP display.
 * (Clears bit 6 on VDP reg. #1)
 */
#define _VDP_DISP_DISA 0x0002DC

/**
 * Decompress graphics data in the "Nemesis" format to VRAM
 * You must set the destination on the VDP control port before calling
 * this routine!
 * 
 * IN:
 *  a1 - Pointer to compressed data
 * BREAK:
 *  None
 */
#define _DECMP_VRAM    0x0002ec

/**
 * Decompress graphics data in the "Nemesis" format to RAM
 */
#define _DECMP_RAM     0x0002f0

#define _VINT_WAIT          0x00304
#define _VINT_WAIT_DEFAULT  0x000308
#define _CLEAR_COMMREGS     0x000340
#define _PAL_FADEOUT        0x000388
/*
VDP layout for Boot ROM

0xb800 - sprite list?
0xa000 (size 0xE00)
0xc000 (size 0x2000)
0xe000 (size 0x2000)

*/

#endif

