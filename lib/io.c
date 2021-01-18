/**
 * \file io.c
 * I/O 
 */

#include "io.h"

#ifdef TARGET_CD
/*
  We're manually pushing/popping regs because it seems A6 is a fixed register
  that GCC is using it for a link/unlk operation
*/
void update_inputs_c() { asm(R"(  movem.l d6-d7/a5-a6, -(sp)
  jsr 0x298
  movem.l (sp)+, d6-d7/a5-a6)");
}

#else

void update_inputs_c() { asm("jsr update_inputs" ::: "d0", "d1", "a0", "a1"); };

#endif

void init_ext_c() { asm("jsr init_ext"); }

u8 get_ext() {
  register u8 value_d0 asm("d0");
  asm("jsr ext_rx" : "=d"(value_d0));
  return value_d0;
}

void put_ext(u8 value) {
  register u8 value_d0 asm("d0") = value;
  asm("jsr ext_tx" ::"d"(value_d0));
}
