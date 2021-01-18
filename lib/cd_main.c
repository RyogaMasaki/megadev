/**
 * \file cd_main.c
 * Gate Array (GA) and BIOS function entry definitions
 * for the Main CPU side
 */

/*
TODO: move this note to documentation

  One of the goals we always have as developers is to minimize and ideally
	eliminate redundancy. We want to define a constant or function or something
	in only once place and share it throughout our program via includes. This
	gets a little tricky when mixing asm and C. GNU AS has the tools for wrapping
	asm calls in C that are flexible enough to get things done, albeit with a 
	pretty steep learning curve, and the ability to preprocess asm source with
	the C preprocessor allows us to define symbols once and use them in any kind
	of source code. There is, however, one relatively minor trouble spot that
	makes things less than perfect: macros. Macros are great for working in asm,
	and it would be nice to use them in C as well, but I have not yet found a
	viable method for doing so. As such, macros are defined in asm and copied as
	inline asm in C. It's not perfect, but it's the best solution I've found after
	many hours struggling against the rather esoteric and inflexible (at least 
	for our uses) methods for inlining asm.

	An interesting trick I've found for including symbols into inline asm is the
	use of tokens constrained as integers, along with the 'p' operand modifier.
	The 'p' modifier inserts the number value "raw," without any syntax prefixes.
	In our case, this allows us to specify an address in a symbol without the
	'#' symbol in front of it. E.g.:
   X  jsr %0  -> jsr #1234
	 O  jsr %p0 -> jsr 1234
	
	The GAS documentation lists 'p' in the x86 operand section, but it seems to
	work anyway with our M68k assembly, so... Hooray. Let's hope it stays that
	way.
*/

#include "cd_main.h"

inline void wait_2m() {
	asm(R"(
1:btst %0, %p1
  beq 1b
)"::"i"(MEMORYMODE_RET_BIT),"i"(GA_MEMORYMODE+1));
}

inline void grant_2m() {
	asm(R"(
1:bset #1, %p0
  btst #1, %p0
	beq 1b
)"::"i"(GA_MEMORYMODE+1));
}

inline void clear_comm_regs() {
	asm(R"(
  lea %p0, a0
  moveq #0, d0
  move.b d0, -2(a0) /* upper byte of comm flags */
  move.l d0, (a0)+
  move.l d0, (a0)+
  move.l d0, (a0)+
  move.l d0, (a0)+
)"::"i"(GA_COMCMD0));
}
