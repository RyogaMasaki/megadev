#include "vdp.h"

void vdp_cram_clear_c() { asm("jsr vdp_cram_clear" ::: "d0", "d7", "a5"); };

void vdp_vram_clear_c() { asm("jsr vdp_vram_clear" ::: "d0", "d7", "a5"); };

void vdp_load_reg_c(u8 reg, u8 value) {
  register u8 d0_reg asm("d0") = reg;
  register u8 d1_value asm("d1") = value;

  asm("jsr vdp_load_reg" ::"d"(d0_reg), "d"(d1_value));
};

void vdp_load_regs_c(u8 const* values) {
  register u8 const* a0_values asm("a0") = values;

  asm("jsr vdp_load_regs" ::"a"(a0_values) : "d6","d7","a5");
}