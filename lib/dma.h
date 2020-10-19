#ifndef MEGADEV__DMA_H
#define MEGADEV__DMA_H

#include "types.h"
#include "vdp.h"

/*
################################################################################
# VDP DMA TRANSFER
# Macros and subroutines for doing DMA transfers
################################################################################
*/

enum VDPADDR_BUS { VRAM = 0b00100001, CRAM = 0b00101011, VSRAM = 0b00100101 };
enum VDPADDR_CMD { READ = 0b00001100, WRITE = 0b00000111, DMA = 0b00100111 };

void vdp_dma_transfer(void const* source, u32 length, u16 dest,
                      enum VDPADDR_BUS bus, enum VDPADDR_CMD command) {
  vdp_dma_transfer_vdpfmt(source, length, VDP_ADDR(dest, bus, command));
};

void vdp_dma_transfer_vdpfmt(void const* source, u32 length, u32 vdpfmt_dest) {
  register u32 source_d0 asm("d0") = (u32)source;
  // TODO this is hardcoded for sega cd right now
  // (reading from PRG RAM needs to be address + 2)
  // change this with #define?
  if (source_d0 < 0xff0000) (source_d0) += 2;
  register u32 length_d1 asm("d1") = length;
  register u32 vdpfmt_dest_d2 asm("d2") = vdpfmt_dest;

  asm("jsr vdp_dma_transfer_sub" ::"d"(source_d0), "d"(length_d1),
      "d"(vdpfmt_dest_d2)
      : "a5");

  return;
};

void vdp_dma_fill(u32 vdpfmt_dest, u16 length, u8 value) {
  register u32 vdpfmt_dest_d0 asm("d0") = vdpfmt_dest;
  register u16 length_d1 asm("d1") = length;
  register u8 value_d2 asm("d2") = value;

  asm("jsr vdp_dma_fill_sub" ::"d"(vdpfmt_dest_d0), "d"(length_d1),
      "d"(value_d2)
      : "d3", "a5");

  return;
};

#endif
