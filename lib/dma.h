/**
 * \file dma.h
 * Direct Memory Access (DMA) functions
 */

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

#define DMA_XFER 0
#define DMA_FILL 1
#define DMA_COPY 2

void vdp_dma_transfer_vdpfmt(void const* source, u32 length, u32 vdpfmt_dest);

void vdp_dma_transfer(void const* source, u32 length, u16 dest,
                      enum VDPADDR_BUS bus, enum VDPADDR_OP command);

void vdp_dma_fill(u8 value, u16 length, u32 vdpfmt_dest);

void dma_enqueue_c(u16 const type, u8 const* source, u16 const length, u32 const vdpfmt_dest);

void dma_process_queue_c();

#endif
