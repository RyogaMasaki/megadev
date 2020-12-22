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

void vdp_dma_transfer_vdpfmt(void const* source, u32 length, u32 vdpfmt_dest);

void vdp_dma_transfer(void const* source, u32 length, u16 dest,
                      enum VDPADDR_BUS bus, enum VDPADDR_OP command);

void vdp_dma_fill(u8 value, u16 length, u32 vdpfmt_dest);

void dma_enqueue_c(u16 type, void const* source, u16 length, u32 vdpfmt_dest);

void dma_process_queue_c();

#endif
