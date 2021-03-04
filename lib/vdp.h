/**
 * \file vdp.h
 * \brief Mega Drive Video Display Processor (VDP)
 */

#ifndef MEGADEV__VDP_H
#define MEGADEV__VDP_H

#include "types.h"
#include "vdp_def.h"

/**
 * VDP control port (32 bit)
 * A 32 bit write to this port is the equivalent to two consecutive 16 bit
 * writes
 */
#define VDP_CTRL_32 (*(volatile u32*)VDP_CTRL)

/**
 * VDP data port (32 bit)
 * A 32 bit write to this port is the equivalent to two consecutive 16 bit
 * writes
 */
#define VDP_DATA_32 (*(volatile u32*)VDP_DATA)

/**
 * VDP control port (16 bit)
 */
#define VDP_CTRL_16 (*(volatile u16*)VDP_CTRL)

/**
 * VDP data port (16 bit)
 */
#define VDP_DATA_16 (*(volatile u16*)VDP_DATA)


/**
 * Generates the nametable data offset for a tile at pos x/y
 * @param x horizontal position in the tilemap
 * @param y vertical position in the tilemap
 * @param width width of the tilemap (32/64/128)
 */
#define NMT_POS(x, y, width) (((y * width) + x) * 2)

#define NMT_POS_PLANE(x, y, width, plane_addr) \
  (NMT_POS(x, y, width) + plane_addr)

/*
################################################################################
# VDP ADDRESS SET
# Macros and subroutines for generating VDP formatted control port command
################################################################################
*/

inline u32 make_vdpaddr(u16 addr) {
  u32 vdpaddr = (u32)addr;
  u32 work;

  asm(R"(
  swap %0
  move.l %0, %1
  rol.l #2, %0
  and.l #3, %0
  or.l %1, %0
  and.l #0x3fff0003, %0
  )" : "+d" (vdpaddr) : "d" (work));

  return vdpaddr;
}

enum VDPADDR_BUS { VRAM = 0b00100001, CRAM = 0b00101011, VSRAM = 0b00100101 };
enum VDPADDR_OP { READ = 0b00001100, WRITE = 0b00000111, DMA = 0b00100111 };

#define VDP_ADDR(addr, bus, op)                         \
  ((((bus & op) & 3) << 30) | ((addr & 0x3FFF) << 16) | \
   (((bus & op) & 0xFC) << 2) | ((addr & 0xC000) >> 14))

#endif
