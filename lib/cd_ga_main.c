/**
 * \file cd_ga_main.c
 * Mega CD GA (Main side) functions
 */

/*
Allow me to rant for a little while.

While I want Megadev to be "asm first," the reality is that I want to be able
to code in either asm or C as seamlessly as possible. That is why so much effort
has been made to provide C wrappers and the like. One thing in particular that
I wanted to achieve is the unifcation of hardware definitions across both
languages. For example, the address of the VDP control port, or the vector
for a Mega CD BIOS call. I want these to be defined just once, in one file, that
could be included from any source file.

That was a relatively low priority as I began to prototype, but eventually I
found the answer by forcing asm files through the C preprocessor with the
assembler-with-cpp option. Now we can have a C style header with a bunch of
defines, includable from either C or asm source. Great!

But things were not perfect. Namely, macros. Macros are important, I feel, as
there are a number of very small bits of repeatable code that are bets suited
to for asm as they don't futz with any registers or the stack. They can be
inlined anywhere without the extra overhead of a function call.

Attempt #1: Write GNU as macros (yech) and reference it from C. Do-able by
adding asm(".include macro.s"); at the top of the C file, which is kind of
gross, but it got the job done. However, doing .include does not run the
include through the preprocessor, so none of our lovely defines are
recognized.

Attempt #2: Do as above, but use asm("#include macro.s"). The file is included,
but the preprocessor doesn't actually seem to do any replacements of the 
defines. Tried a variation of this by forcing the filename extension to .S.
No dice.

Attempt #3: Okay, pulling in asm macros isn't working. What if we set the asm
itself just as a string set in a #define and reference that in both asm and C
macro files... Nope. Between trying to use raw strings and that awful backslash
escaped multline format (those two didn't play nice together) and the mess of
support files that it was requiring from trying to do it this way (macro file
for asm, macro header for C, macro implementation for C... for each macro set)
this was just bad.

Attempt #4: And in any case, even if I had gotten the above working, I would
have hit the next issue: C definitions (like the macros in #1) are not available
to inline asm. Like with #1, you could asm(".include") a file with said defines,
but then we're back to the issue of the included file not being properly pre-
processed.

At this point, gcc had broken and beaten me, and here we are with the result.
Inline asm, with redundant code from the asm macro file, and unable to use the
global defines. We have a .equ list at the top that sot-of kind-of helps, and I
suppose this isn't nearly as bad of a solution as I'm making it out to be, I
just *hate* having redundant code/definitions/etc across files.

But whatever. You win, gcc.
*/

#include "cd_ga_main.h"

asm(R"(
	.equ GA_MEMORYMODE, 0xA12002
	.equ MEMORYMODE_RET_BIT, 0
)");


inline void wait_2m() {
	asm(R"(
1:btst		#MEMORYMODE_RET_BIT, GA_MEMORYMODE+1
  beq 1b
)");
}

inline void grant_2m() {
asm(R"(
1:bset #1, GA_MEMORYMODE+1
  btst #1, GA_MEMORYMODE+1
	beq 1b
)");
}
