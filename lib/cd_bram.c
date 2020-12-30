#include "cd_bram.h"

BramInitInfo init_info;

void bram_init_c() {
  // TODO - BRMINIT bios call
  register u16 d0_bram_size asm("d0");
  register enum BramStatus d1_bram_status asm("d1");

  asm("jsr bram_init" : "=d"(d0_bram_size), "=d"(d1_bram_status));

  init_info.bram_size = d0_bram_size;
  init_info.status = d1_bram_status;
}

s16 bram_find_file_c(u8 const* filename) {
  // TODO - BRMSERCH bios calltest_latest_latest_la
}
