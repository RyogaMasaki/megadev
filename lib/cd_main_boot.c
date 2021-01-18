/**
 * \file cd_main_boot.c
 * Boot ROM (Main CPU) system calls
 */

#include "types.h"
#include "cd_main_boot.h"

void decompress_nemesis_vram(u8* data) {
  register u32 a1_data asm("a1") = (u32)data;
  asm("jsr %p0" ::"i"(_DECMP_VRAM), "a"(a1_data));
}

void load_vdp_regs(u16* reg_data) {
	register u32 a1_reg_data asm("a1") = (u32)reg_data;
	asm("jsr %p0" ::"i"(_VDP_REG_LOAD), "a"(a1_reg_data));
};

void vdp_enable_display() {
	asm("jsr %p0" :: "i"(_VDP_DISP_ENAB));
}

void vdp_disable_display() {
	asm("jsr %p0" :: "i"(_VDP_DISP_DISA));
}

void vint_wait() {
	asm("jsr %p0" :: "i"(_VINT_WAIT_DEFAULT));
}

void vint_wait_ex(u8 flags) {
	register u8 d0_flags asm("d0") = flags;
	asm("jsr %p0" :: "i"(_VINT_WAIT), "d"(flags));
}

void update_inputs() {
	/*
  We're manually pushing/popping regs because it seems A6 is a fixed register
  that GCC is using for a link/unlk operation
  */
	asm(R"(
  movem.l d6-d7/a5-a6,-(sp)
	jsr %p0
	movem.l (sp)+, d6-d7/a5-a6)" :: "i"(_UPDATE_INPUT));
}
