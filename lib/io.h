/**
 * \file io.h
 * \brief IO utilities
 */

#ifndef MEGADEV__IO_H
#define MEGADEV__IO_H

#include "io_def.h"
#include "types.h"

/**
 * \fn init_ext
 * \brief Initialize IO port for serial communication
 */
extern void init_ext();

/**
 * \fn ext_rx_c
 * \brief Wrapped for \ref ext_rx
 */
inline u8 ext_rx_c() {
	register u8 d0_data asm("d0");
	asm("jsr ext_rx" : "d"(d0_data));
}

/**
 * \fn ext_rx_c
 * \brief Wrapped for \ref ext_rx
 */
inline void ext_tx_c(u8 data) {
	register u8 d0_data asm("d0") = data;
	asm("jsr ext_tx" :: "d"(d0_data));
}

#endif
