#ifndef MEGADEV__VDP_H
#define MEGADEV__VDP_H

#include "types.h"

/**
 * Generates the nametable data offset for a tile at pos x/y
 * @param x horizontal position in the tilemap
 * @param y vertical position in the tilemap
 * @param width width of the tilemap (32/64/128)
 */
#define nmt_pos(x, y, width) (((y * width) + x) * 2)

#define nmt_pos_plane(x, y, width, plane_addr) \
  (nmt_pos(x, y, width) + plane_addr)

enum PalLine { Line0, Line1, Line2, Line3 };

/*
################################################################################
# VDP ADDRESS SET
# Macros and subroutines for generating VDP formatted control port command
################################################################################
*/

#define VRAM 0b00100001
#define CRAM 0b00101011
#define VSRAM 0b00100101

#define READ 0b00001100
#define WRITE 0b00000111
#define DMA 0b00100111

#define VDP_ADDR(addr, ram, cmd)                        \
  (((ram & cmd) & 3) << 30) | ((addr & 0x3FFF) << 16) | \
      (((ram & cmd) & 0xFC) << 2) | ((addr & 0xC000) >> 14)

/*
################################################################################
# VDP DMA TRANSFER
# Macros and subroutines for doing DMA transfers
################################################################################
*/

void vdp_dma_transfer(void* source_addr, unsigned int length,
                      unsigned int vdp_dest_addr, int from_word_ram) {
  register unsigned int sa_d0 asm("d0") = source_addr;
  if (from_word_ram == TRUE) sa_d0 += 2;
  register unsigned int l_d1 asm("d1") = length;
  register unsigned int da_d2 asm("d2") = vdp_dest_addr;

  asm("jsr vdp_dma_transfer_sub" ::"d"(sa_d0), "d"(l_d1), "d"(da_d2) : "a5");

  return;
};

void vdp_dma_fill(void* dest_addr, u16 length, u8 value) {
  register u32 dest_addr_d0 asm("d0") = dest_addr;
  register u16 length_d1 asm("d1") = length;
  register u8 value_d2 asm("d2") = value;

  asm("jsr vdp_dma_fill_sub" ::"d"(dest_addr_d0), "d"(length_d1), "d"(value_d2)
      : "d3", "a5");

  return;
};

struct TilePosInfo {
  u32 NametableOffset;
  u16 TilesPerRow;
};

struct TilePosInfo vdp_xy_pos_c(u16 xy_pos) {
  struct TilePosInfo _out;
  register u32 d0_out asm("d0");
  register u16 d1_out asm("d1");

  register u16 xy_pos_d0 asm("d0") = xy_pos;
  asm("jsr vdp_xy_pos" : "=d"(d0_out), "=d"(d1_out) : "d"(xy_pos_d0) : "d2");

  _out.NametableOffset = d0_out;
  _out.TilesPerRow = d1_out;
  return _out;
};

void vdp_cram_clear_c() { asm("jsr vdp_cram_clear" ::: "d0", "d7", "a5"); };

void vdp_vram_clear_c() { asm("jsr vdp_vram_clear" ::: "d0", "d7", "a5"); };

// VDP ports
#define VDP_DATA 0xC00000
#define VDP_CTRL 0xC00004
#define VDP_HVCOUNT 0xC00008

// VDP registers
#define VDP_REG00 0x8000
#define VDP_REG01 0x8100
#define VDP_REG02 0x8200
#define VDP_REG03 0x8300
#define VDP_REG04 0x8400
#define VDP_REG05 0x8500
#define VDP_REG06 0x8600
#define VDP_REG07 0x8700
#define VDP_REG08 0x8800
#define VDP_REG09 0x8900
#define VDP_REG0A 0x8A00
#define VDP_REG0B 0x8B00
#define VDP_REG0C 0x8C00
#define VDP_REG0D 0x8D00
#define VDP_REG0E 0x8E00
#define VDP_REG0F 0x8F00
#define VDP_REG10 0x9000
#define VDP_REG11 0x9100
#define VDP_REG12 0x9200
#define VDP_REG13 0x9300
#define VDP_REG14 0x9400
#define VDP_REG15 0x9500
#define VDP_REG16 0x9600
#define VDP_REG17 0x9700

#endif
