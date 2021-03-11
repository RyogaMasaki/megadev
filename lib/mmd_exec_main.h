#ifndef MEGADEV__MMD_EXEC_MAIN_H
#define MEGADEV__MMD_EXEC_MAIN_H

/**
 * \brief Setup and run a loaded MMD formatted module
 * \note This expects the module to be already loaded at the start of 2M
 * Word RAM
 */
inline void mmd_exec_c() {
	asm("jsr mmd_exec" ::: "d0", "d7", "a0", "a1");
}

#endif
