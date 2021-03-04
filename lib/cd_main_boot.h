/**
 * \file cd_main_boot.h
 * Boot ROM (Main CPU) system calls
 */

#ifndef MEGADEV__CD_MAIN_BOOT_H
#define MEGADEV__CD_MAIN_BOOT_H

#include "types.h"
#include "cd_main_boot_def.h"

/**
 * Sprite list RAM cache
 * Size: 0x280
 */
#define SPRITE_LIST ((volatile u16*)_SPRITE_LIST)

/**
 * Array of VDP registers cached in RAM. This must be updated manually unless
 * you use load_vdp_regs. Contains 19 entries, one for each register (except
 * for the DMA regs).
 */
#define VDP_REGS ((volatile u16*)_VDP_REGS)

/**
 * CRAM (palette) RAM cache 
 */
#define PALETTE ((u16*)_PALETTE)

/**
 * VINT task flags
 */
#define VINT_FLAGS (*(volatile u8*)_VINT_FLAGS)

/**
 * Graphics update flags
 */
#define GFX_REFRESH (*(volatile u8*)_GFX_REFRESH)

#define PLANE_WIDTH (*(u16*)_PLANE_WIDTH)

#define TILE_BASE (*(u16*)_TILE_BASE)

/**
 * P1 Controller input (hold)
 */
#define PAD_P1_HOLD (*(volatile u8*)_INPUT_P1_HOLD)

/**
 * P1 Controller input (single press)
 */
#define PAD_P1_PRESS (*(volatile u8*)_INPUT_P1_PRESS)

/**
 * P2 Controller input (hold)
 */
#define PAD_P2_HOLD (*(volatile u8*)_INPUT_P2_HOLD)

/**
 * P2 Controller input (single press)
 */
#define PAD_P2_PRESS (*(volatile u8*)_INPUT_P2_PRESS)

/**
 * \brief Wrapper for \ref _BOOT_VINT
 */
inline void boot_vint() {
	asm("jsr %p0" :: "i"(_BOOT_VINT));
}

/**
 * \brief Wrapper for \ref _BOOT_SET_HINT_DEFAULT
 * \todo Look into properly making the pointer 16 bit
 */
inline void boot_set_hint_default(void* hint_routine) {
	register u16 a1_ptr asm("a1") = (u16)hint_routine;
	asm("jsr %p0" :: "i"(_BOOT_SET_HINT_DEFAULT), "a"(a1_data));
}

/**
 * \brief Wrapper for \ref _BOOT_UPDATE_INPUT
 */
inline void boot_update_input() {
	asm(R"(
  move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6)" :: "i"(_BOOT_UPDATE_INPUT) : "d6", "d7", "a5");
}

/**
 * \brief Wrapper for \ref _BOOT_CLEAR_VRAM
 */
inline void boot_clear_vram() {
	asm(R"(
  move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6)" :: "i"(_BOOT_CLEAR_VRAM) : "d0", "d1", "d2", "d3");
}

/**
 * \brief Wrapper for \ref _BOOT_CLEAR_NMTBL
 */
inline boot_clear_nmtbl() {
	asm(R"(
  move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6)" :: "i"(_BOOT_CLEAR_NMTBL) : "d0", "d1", "d2", "d3");
}

/**
 * \brief Wrapper for \ref _BOOT_CLEAR_VSRAM
 */
inline void boot_clear_vsram() {
	asm("jsr %p0" :: "i"(_BOOT_CLEAR_VSRAM) : "d0", "d1", "d2");
}

/**
 * Wrapper for \ref _BOOT_LOAD_VDPREGS_DEFAULT
 */
inline void boot_load_vdpregs_default() {
	asm("jsr %p0" :: "i"(_BOOT_LOAD_VDPREGS_DEFAULT) : "d0", "d1", "a1", "a2");
}

/**
 * \brief Wrapper for \ref _BOOT_LOAD_VDPREGS
 */
inline void boot_load_vdpregs(void* hint_routine) {
	register u32 a1_vdpregs asm("a1") = (u32)hint_routine;
	asm("jsr %p0" :: "i"(_BOOT_LOAD_VDPREGS), "a"(a1_vdpregs) : "d0", "d1", "a2");
}

/**
 * Wrapper for \ref _BOOT_VDP_FILL
 */
inline boot_vdp_fill(u32 vdpaddr, u16 length, u16 value) {
	register u32 d0_vdpaddr asm("d0") = vdpaddr;
	register u16 d1_length asm("d1") = length;
	register u16 d2_value asm("d2") = value;
	asm("jsr %p0" :: "i"(_BOOT_VDP_FILL), "d"(d0_vdpaddr), "d"(d1_length), "d"(d2_value));
}

/**
 * Wrapper for \ref _BOOT_VDP_FILL_CLEAR
 */
inline boot_vdp_fill_clear(u32 vdpaddr, u16 length) {
	register u32 d0_vdpaddr asm("d0") = vdpaddr;
	register u16 d1_length asm("d1") = length;
	asm("jsr %p0" :: "i"(_BOOT_VDP_FILL_CLEAR), "d"(d0_vdpaddr), "d"(d1_length) : "d2");
}

/**
 * Wrapper for \ref _BOOT_DMA_FILL_CLEAR
 */
inline boot_dma_fill_clear(u32 vdpaddr, u16 length) {
	register u32 d0_vdpaddr asm("d0") = vdpaddr;
	register u16 d1_length asm("d1") = length;
	asm(R"(
  move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6)" :: "i"(_BOOT_DMA_FILL_CLEAR), "d"(d0_vdpaddr), "d"(d1_length) : "d2", "d3");	
}

/**
 * Wrapper for \ref _BOOT_DMA_FILL
 */
inline boot_dma_fill(u32 vdpaddr, u16 length, u16 value) {
	register u32 d0_vdpaddr asm("d0") = vdpaddr;
	register u16 d1_length asm("d1") = length;
	register u16 d2_value asm("d2") = value;
	asm(R"(
  move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6)" :: "i"(_BOOT_DMA_FILL), "d"(d0_vdpaddr), "d"(d1_length), "d"(d2_value) : "d3");
}

/**
 * Wrapper for \ref _BOOT_LOAD_MAP
 */
inline boot_load_map(u32 vdpaddr, u16 width, u16 height, void* map) {
	register u32 d0_vdpaddr asm("d0") = vdpaddr;
	register u16 d1_width asm("d1") = width;
	register u16 d2_height asm("d2") = height;
	register u32 a1_map asm("a1") = (u32)map;
	asm("jsr %p0" :: "i"(_BOOT_LOAD_MAP), "d"(d0_vdpaddr), "d"(d1_width), "d"(d2_height), "a"(a1_map) : "d3", "a5");
}

/**
 * Decompress graphics data in the "Nemesis" format to VRAM
 * You must set the destination on the VDP control port before calling
 * this routine!
 * 
 */
inline void decompress_nemesis_vram(u8* data) {
  register u32 a1_data asm("a1") = (u32)data;
  asm("jsr %p0" ::"i"(_DECMP_VRAM), "a"(a1_data));
}

/**
 * Load multiple values into VDP registers. 
 * Data should consist of word sized values, where the upper byte is the
 * register ID (e.g. 80, 81, etc) and the lower byte is the value. Each value
 *  will be stored in RAM in VDP_REG_CACH.
 */
inline void load_vdp_regs(u16 const * reg_data) {
	register u32 a1_reg_data asm("a1") = (u32)reg_data;
	asm("jsr %p0" ::"i"(_VDP_REG_LOAD), "a"(a1_reg_data));
};

/**
 * Enable VDP output
 * (Controls the setting in VDP Reg. #1)
 */
inline void vdp_enable_display() {
	asm("jsr %p0" :: "i"(_VDP_DISP_ENABLE));
}

/**
 * Disable VDP output
 * (Controls the setting in VDP Reg. #1)
 */
inline void vdp_disable_display() {
	asm("jsr %p0" :: "i"(_VDP_DISP_DISABLE));
}

inline void vint_wait() {
	asm("jsr %p0" :: "i"(_VINT_WAIT_DEFAULT));
}

inline void vint_wait_ex(u8 flags) {
	register u8 d0_flags asm("d0") = flags;
	asm("jsr %p0" :: "i"(_VINT_WAIT), "d"(d0_flags));
}

extern bool vdp_pal_fadeout(u8 index, u8 length);

inline void load_internal_font() {
	asm(R"(jsr %p0)" :: "i"(_LOAD_FONT_INTERN_DEFAULTS) : "d0", "d1", "d2", "d3", "d4", "a1", "a5");
};

inline void print_text(u8 const * string, u32 vdpaddr_pos) {
	register u32 a1_string asm("a1") = (u32)string;
	register u32 d0_vdpaddr_pos asm("d0") = vdpaddr_pos;

	asm(R"(jsr %p0)" :: "i"(_PRINT_TEXT), "a"(a1_string), "d"(d0_vdpaddr_pos));

};

inline void vdp_clear_vram() {
	asm(R"(
  move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6
)" :: "i"(_VDP_CLEAR_VRAM) : "d0","d1","d2","d3");
};

inline void vdp_clear_nmtbl() {
	asm(R"(
	move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6
)" :: "i"(_VDP_CLEAR_NMTBL) : "d0","d1","d2","d3");
};


inline void vdp_dma_xfer(u32 vdpaddr_dest, u8 const * source, u16 length) {
	register u32 d0_vdpaddr_dest asm("d0") = vdpaddr_dest;
	register u32 d1_source asm("d1") = (u32)source;
	register u16 d2_length asm("d2") = length;

	asm(R"(
  move.l a6, -(sp)
  jsr %p0
  move.l (sp)+, a6
)" :: "i"(_VDP_DMA_XFER), "d"(d0_vdpaddr_dest), "d"(d1_source), "d"(d2_length) : "d3");
};

inline void vdp_dma_wordram_xfer(u32 vdpaddr_dest, u8 const * source, u16 length) {
	register u32 d0_vdpaddr_dest asm("d0") = vdpaddr_dest;
	register u32 d1_source asm("d1") = (u32)source;
	register u16 d2_length asm("d2") = length;

	asm(R"(
	move.l a6, -(sp)
  jsr %p0
	move.l (sp)+, a6
)"::"i"(_VDP_DMA_WORDRAM_XFER), "d"(d0_vdpaddr_dest), "d"(d1_source), "d"(d2_length) : "d3");
};

inline void vdp_dma_fill_new(u32 vdpaddr, u16 length, u8 value) {
	register u32 d0_vdpaddr asm("d0") = vdpaddr;
	register u16 d1_length asm("d1") = length;
	register u8 d2_value asm("d2") = value;

	asm(R"(
  move.l a6, -(sp)
  jsr %p0
  move.l (sp)+, a6
)" :: "i"(_VDP_DMA_FILL), "d"(d0_vdpaddr), "d"(d1_length), "d"(d2_value) : "d3");
};

inline void vdp_dma_copy(u32 vdpaddr, u16 source, u16 length) {
	register u32 d0_vdpaddr asm("d0") = vdpaddr;
	register u16 d1_source asm("d1") = source;
	register u16 d2_length asm("d2") = length;

	asm(R"(
  move.l a6, -(sp)
  jsr %p0
  move.l (sp)+, a6
)" :: "i"(_VDP_DMA_COPY), "d"(d0_vdpaddr), "d"(d1_source), "d"(d2_length) : "d3");
};

inline void vdp_copy_sprlist(){
	asm("jsr %p0" :: "i"(_COPY_SPRLIST) : "d4", "a4");
};


inline void clear_region(u8* region, u32 long_count) {
	register u32 a0_region asm("a0") = (u32)region;
	register u32 d7_long_count asm("d7") = long_count;

	asm(R"(
	move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6
)" :: "i"(_CLEAR_REGION), "d"(d7_long_count), "a"(a0_region));

};


/**
 * Poll controllers
 */
inline void update_inputs() {
	/*
  We're manually pushing/popping because it seems A6 is a fixed register
  that GCC is using for a link/unlk operation
  */
	asm(R"(
  move.l a6,-(sp)
	jsr %p0
	move.l (sp)+, a6)" :: "i"(_UPDATE_INPUT) : "d6","d7","a5");
};

inline void palette_load(u8* pal_data) {
	register u32 a1_pal_data asm("a1") = (u32)pal_data;

	asm(R"(jsr %p0)" :: "i"(_PAL_LOAD), "a"(a1_pal_data) : "d0");
};


#endif
