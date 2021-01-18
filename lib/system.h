#ifndef MEGADEV__SYSTEM_H
#define MEGADEV__SYSTEM_H

extern void md_standard_init();

// TODO: add "safe" version that pushes/pops SR to preserve values

inline void disable_interrupts() { asm("ori #0x700,sr"); }

inline void enable_interrupts() { asm("andi #0xF8FF,sr"); }

#endif
