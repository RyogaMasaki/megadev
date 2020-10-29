#ifndef MEGADEV__SYSTEM_H
#define MEGADEV__SYSTEM_H

extern void md_standard_init();

inline void disable_interrupts() { asm("move #0x2700, sr	"); }

inline void enable_interrupts() { asm("move	#0x2000, sr	"); }
#endif
