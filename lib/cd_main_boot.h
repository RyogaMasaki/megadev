/**
 * \file cd_main_boot.c
 * Boot ROM (Main CPU) system calls
 */

#ifndef MEGADEV__CD_MAIN_BOOT_C
#define MEGADEV__CD_MAIN_BOOT_C

#include "types.h"
#include "cd_main_boot_def.h"

/**
 * Sprite list RAM cache
 * Size: 0x280
 */
#define SPRITE_LIST ((volatile u16*)_SPRITE_LIST)

/**
 * Array of VDP registers cached in RAM. This must be updated manually unless
 * you use load_vdp_regs. Contains 19 entries, one for each register except
 * for the DMA regs.
 */
#define VDP_REGS ((volatile u16*)_VDP_REGS)

/**
 * CRAM (palette) RAM cache 
 */
#define PALETTE ((u16*)_PALETTE)

#define VINT_FLAGS (*(volatile u8*)_VINT_FLAGS)

#define GFX_REFRESH (*(volatile u8*)_GFX_REFRESH)

/**
 * Decompress graphics data in the "Nemesis" format to VRAM
 * You must set the destination on the VDP control port before calling
 * this routine!
 * 
 */
extern void decompress_nemesis_vram(u8* data);

/**
 * Load multiple values into VDP registers. 
 * Data should consist of word sized values, where the upper byte is the
 * register ID (e.g. 80, 81, etc) and the lower byte is the value. Each value
 *  will be stored in RAM in VDP_REG_CACH.
 */
extern void load_vdp_regs(u16* reg_data);

extern void vdp_enable_display();

extern void vdp_disable_display();

extern void vint_wait();

extern void vdp_pal_fadeout(u8 index, u8 length);

#define PAD_P1_HOLD (*(volatile u8*)_INPUT_P1_HOLD)
#define PAD_P1_PRESS (*(volatile u8*)_INPUT_P1_PRESS)

#define PAD_P2_HOLD (*(volatile u8*)_INPUT_P2_HOLD)
#define PAD_P2_PRESS (*(volatile u8*)_INPUT_P2_PRESS)



/**
 * Poll controllers
 */
extern void update_inputs();

#endif
