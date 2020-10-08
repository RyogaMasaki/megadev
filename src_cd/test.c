#include "io.h"
#include "print.h"
#include "res.h"
#include "system.h"
#include "tilemap.h"
#include "types.h"
#include "vdp.h"
#include "sysres.h"

u16 vram_use_offset = 0;

const char vdp_init_regs[0x18] = {
    0b00000100,     /* 00: Mode Register 1 */
    0b01110100,     /* 01: Mode Register 2 */
    (0xc000 >> 10), /* 02: Plane A Name Table Address */
    (0xF000 >> 10), /* 03: Window Name Table Address */
    (0xE000 >> 13), /* 04: Plane B Name Table Address */
    (0xE000 >> 9),  /* 05: Sprite Table Address */
    0x00,           /* 06: Bit 16 of Sprite Table Address for 128k VRAM */
    0b00000000,     /* 07: Background color */
    0x00,           /* 08: Unused (Mark III Horiz Scroll Register) */
    0x00,           /* 09: Unused (Mark III Vert Scroll Register) */
    0x00,           /* 0A: Horiz Interrupt Counter */
    0x08,           /* 0B: Mode Register 3 */
    0b10000001,     /* 0C: Mode Register 4 */
    (0xD000 >> 10), /* 0D: Horiz. scroll table at 0xD000 (bits 0-5) */
    0x00,           /* 0E: Plane A/B Name Table Address bits for 128k VRAM */
    0x02,           /* 0F: Autoincrement value */
    0x11,           /* 10: Plane Size (64x32) */
    0x00,           /* 11: Window Plane X pos */
    0x00,           /* 12: Window Plane Y pos */
    0x00,           /* 13: DMA Length lo byte */
    0x00,           /* 14: DMA Length hi byte */
    0x00,           /* 15: DMA Source Address lo byte */
    0x00,           /* 16: DMA Source Address mid byte */
    0x00            /* 17: DMA Source Address hi byte & DMA Mode */
};

int main() {
  vdp_load_registers_c(vdp_init_regs);
  vram_clear();
  cram_clear();
  cram_load_palette_c(&sysfont_pal, 16, 0);
  vram_load_tiles_c(&sysfont_chr, 65, 0);
  vram_use_offset = 65;

  vram_load_tiles_c(&res_border_chr, 139, vram_use_offset);

  u8 test1 = 115;
  printval_u8_c(&test1, 0x0f08);

  u16 test2 = 1045;
  printval_u16_c(&test2, 0x0f09);

  u32 test3 = 100003;
  printval_u32_c(&test3, 0x0f0a);

  u8 x = 0;
  unsigned int wait = 0;
  do {
    vblank_wait();
    update_inputs();
    if (wait < 3) {
      ++wait;
    } else {
      print_c("TEST", (x << 8) | 4);
      x++;
      if (x > 10) x = 0;
      wait = 0;
    }
  } while (1);
}
