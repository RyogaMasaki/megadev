#include "io.h"

void update_inputs_c() { asm("jsr update_inputs" ::: "d0", "d1", "a0", "a1"); };
