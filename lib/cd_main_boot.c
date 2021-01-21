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

void vdp_clear_nmtbl() {
	asm(R"(
	move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6
)" :: "i"(_VDP_CLR_NMTBL) : "d0","d1","d2","d3");
};

void vint_wait() {
	asm("jsr %p0" :: "i"(_VINT_WAIT_DEFAULT));
}

void vint_wait_ex(u8 flags) {
	register u8 d0_flags asm("d0") = flags;
	asm("jsr %p0" :: "i"(_VINT_WAIT), "d"(d0_flags));
}

bool vdp_pal_fadeout(u8 index, u8 length) {
	// code expects 16 bit values, even though it all fits in
	// a byte...
	register u16 d0_index asm("d0") = (u16)index;
	register u16 d1_length asm("d1") = (u16)length;
	bool is_complete;
	asm(R"(
  jsr %p1
	beq 1f
	move.b #0, %0
	rts
1:move.b #1, %0
  rts
	)" : "=d"(is_complete) : "i"(_PAL_FADEOUT), "d"(d0_index), "d"(d1_length));

	return is_complete;
};


void vdp_dma_xfer(u32 vdpaddr_dest, u8* source, u16 length) {
	register u32 d0_vdpaddr_dest asm("d0") = vdpaddr_dest;
	register u32 d1_source asm("d1") = (u32)source;
	register u16 d2_length asm("d2") = length;

	asm(R"(
  move.l a6, -(sp)
  jsr %p0
  move.l (sp)+, a6
)" :: "i"(_VDP_DMA_XFER), "d"(d0_vdpaddr_dest), "d"(d1_source), "d"(d2_length) : "d3");
};

void vdp_dma_wordram_xfer(u32 vdpaddr_dest, u8* source, u16 length) {
	register u32 d0_vdpaddr_dest asm("d0") = vdpaddr_dest;
	register u32 d1_source asm("d1") = (u32)source;
	register u16 d2_length asm("d2") = length;

	asm(R"(
	move.l a6, -(sp)
  jsr %p0
	move.l (sp)+, a6
)"::"i"(_VDP_DMA_WORDRAM_XFER), "d"(d0_vdpaddr_dest), "d"(d1_source), "d"(d2_length) : "d3");
};


void vdp_clear_vram() {
	asm(R"(
  move.l a6, -(sp)
	jsr %p0
	move.l (sp)+, a6
)" :: "i"(_VDP_CLR_VRAM) : "d0","d1","d2","d3");
};

void update_inputs() {
	/*
  We're manually pushing/popping because it seems A6 is a fixed register
  that GCC is using for a link/unlk operation
  */
	asm(R"(
  move.l a6,-(sp)
	jsr %p0
	move.l (sp)+, a6)" :: "i"(_UPDATE_INPUT) : "d6","d7","a5");
}

void vdp_copy_sprlist(){
	asm("jsr %p0" :: "i"(_COPY_SPRLIST) : "d4", "a4");
};

