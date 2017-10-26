MegaDev
=======
A very minimal Sega Megadrive development framework in M68000 assembly.

Assembler
---------
Uses GNU assembler (gas) directives with the m68k-coff target. Note that the last version of binutils to support m68k-coff is 2.16.1 and the last version of gcc to support it is 3.4.2. You will need to build a cross-compiler using these versions to compile. See this page for more details: http://darkdust.net/index.php/writings/megadrive/crosscompiler

If 'make install' is failing due to problems with texinfo, we can skip the documentation installation. Run this command in any directory where there is a Makefile present:

	echo "MAKEINFO = :" >> Makefile

DISCLAIMER
----------
This project is primarily a personal one to sharpen assembly coding skills as well as to familiarize myself with Megadrive hardware and development. Things probably won't be 100% optimal.

