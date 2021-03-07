/**
 * \file vdp.h
 * \brief Mega Drive Video Display Processor (VDP)
 */

#ifndef MEGADEV__VDP_H
#define MEGADEV__VDP_H

#include "types.h"
#include "vdp_def.h"

/**
 * \var VDP_CTRL_32
 * \brief VDP control port (32 bit)
 * \notes A 32 bit write to this port is the equivalent to two consecutive
 * 16 bit writes
 */
#define VDP_CTRL_32 (*(volatile u32*)VDP_CTRL)

/**
 * \var VDP_DATA_32
 * \brief VDP data port (32 bit)
 * \note A 32 bit write to this port is the equivalent to two consecutive
 * 16 bit writes
 */
#define VDP_DATA_32 (*(volatile u32*)VDP_DATA)

/**
 * \var VDP_CTRL_16
 * \brief VDP control port (16 bit)
 */
#define VDP_CTRL_16 (*(volatile u16*)VDP_CTRL)

/**
 * \var VDP_DATA_16
 * \brief VDP data port (16 bit)
 */
#define VDP_DATA_16 (*(volatile u16*)VDP_DATA)


/**
 * \brief Generates the nametable offset for a tile at pos x/y
 * \param x horizontal position in the tilemap
 * \param y vertical position in the tilemap
 * \param width width of the tilemap (32/64/128)
 */
#define NMT_POS(x, y, width) (((y * width) + x) * 2)

/**
 * \brief Generates the address of a nametable tile at pos x/y
 */
#define NMT_POS_PLANE(x, y, width, plane_addr) \
  (NMT_POS(x, y, width) + plane_addr)

/**
 * \fn to_vdpaddr
 * \brief Converts a 16 bit VRAM address into VDP format
 */
inline u32 to_vdpaddr(u16 addr) {
  u32 vdpaddr = (u32)addr;
  u32 work;

/*
  asm(R"(
  swap %0
  move.l %0, %1
  rol.l #2, %0
  and.l #3, %0
  or.l %1, %0
  and.l #0x3fff0003, %0
  )" : "+d" (vdpaddr) : "d" (work));
*/
  
  
  asm(R"(
  and.l #0xffff, %0
  lsl.l #2, %0
  lsr.w #2, %0
  swap %0
  )" : "+d"(vdpaddr));

  return vdpaddr;
}

#endif
