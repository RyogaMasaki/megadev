#include "print.h"

void print_c(char* string, u16 nametable_offset) {
  register char* string_a0 asm("a0") = string;
  register u16 nametable_offset_d1 asm("d0") = nametable_offset;

  asm("jsr print" ::"a"(string_a0), "d"(nametable_offset_d1) : "a5");
};
