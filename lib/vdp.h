#ifndef MEGADEV__VDP_H
#define MEGADEV__VDP_H

#include "types.h"

// VDP ports
/*
#define VDP_DATA 0xC00000
#define VDP_CTRL 0xC00004
#define VDP_HVCOUNT 0xC00008
*/

#define VDP_CTRL_32 (*(volatile u32*)0xC00004)
#define VDP_DATA_32 (*(volatile u32*)0xC00000)

#define VDP_CTRL_16 (*(volatile u16*)0xC00004)
#define VDP_DATA_16 (*(volatile u16*)0xC00000)

// All VDP registers
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

// Alias to some of the more useful registers

/**
 * Width/height of graphics planes
 */
#define VREG_PLANE_SZ VDP_REG10

/**
 * DMA length low byte (16 bit)
 */
#define VREG_DMA_SZ_LO VDP_REG13

/**
 * DMA length high byte (16 bit)
 */
#define VREG_DMA_SZ_HI VDP_REG14

/**
 * DMA source address low byte (22/23 bit)
 */
#define VREG_DMA_SRC_LO VDP_REG15

/**
 * DMA source address mid byte (22/23 bit)
 */
#define VREG_DMA_SRC_MD VDP_REG16

/**
 * DMA source address high byte (22/23 bit)
 *
 * If doing 68k -> VRAM transfer, bit 6 is used as the top bit of the source
 * address (23 bit source address)
 * If doing VRAM -> VRAM copy, both bits 6 and 7 must be set (22 bit source
 * address)
 */
#define VREG_DMA_SRC_HI VDP_REG17

// Status Register Bits
#define PAL_HARDWARE 0x0001
#define DMA_IN_PROGRESS 0x0002
#define HBLANK_IN_PROGRESS 0x0004
#define VBLANK_IN_PROGRESS 0x0008
#define ODD_FRAME 0x0010
#define SPR_COLLISION 0x0020
#define SPR_LIMIT 0x0040
#define VINT_TRIGGERED 0x0080
#define FIFO_FULL 0x0100
#define FIFO_EMPTY 0x0200

enum PlaneWidth { Width32 = 5, Width64 = 6, Width128 = 7 };

// extern u8 vdp_regs[0x18];
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

// bus
//#define VRAM 0b00100001
//#define CRAM 0b00101011
//#define VSRAM 0b00100101

// command
//#define READ 0b00001100
//#define WRITE 0b00000111
//#define DMA 0b00100111

enum VDPADDR_BUS { VRAM = 0b00100001, CRAM = 0b00101011, VSRAM = 0b00100101 };
enum VDPADDR_OP { READ = 0b00001100, WRITE = 0b00000111, DMA = 0b00100111 };

#define VDP_ADDR(addr, bus, op)                         \
  ((((bus & op) & 3) << 30) | ((addr & 0x3FFF) << 16) | \
   (((bus & op) & 0xFC) << 2) | ((addr & 0xC000) >> 14))

/**
 * Clear all CRAM
 * Sends data via data port; does not use DMA
 */
void vdp_cram_clear_c();

/**
 * Clear all VRAM
 * Sends data via data port; does not use DMA
 */
void vdp_vram_clear_c();

/**
 * Wait for DMA operations to complete
 */
void vdp_wait_dma_c();

/**
 * Set a single VDP register with a value
 */
void vdp_load_reg_c(u8 reg, u8 value);

/**
 * Set all VDP registers from an array
 * Array should contain 24 elements
 */
void vdp_load_regs_c(u8 const* values);

#endif
