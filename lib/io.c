#include "io.h"

void update_inputs_c() { asm("jsr update_inputs" ::: "d0", "d1", "a0", "a1"); };

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
