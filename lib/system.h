#ifndef MEGADEV__SYSTEM_H
#define MEGADEV__SYSTEM_H

/**
 * Disables all interrupt levels; preserves other bits
 */
inline void disable_interrupts() { asm("ori #0x700,sr"); }

/**
 * Enables all interrupt levels; preserves other bits
 */
inline void enable_interrupts() { asm("andi #0xF8FF,sr"); }

#endif
