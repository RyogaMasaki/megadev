MegaDev
=======
A very minimal Sega Megadrive development framework in M68000 assembly.

Toolchain
---------
The code is written for the GNU assembler (GAS) with the m68k-elf target. If you do not already have a toolchain setup, you'll need to compile Binutils and (optionally) GCC

Binutils:
	./configure --prefix=$OPTDIR --target=m68k-elf

GCC:
	./configure --prefix=$OPTDIR --target=m68k-elf --enable-languages=c --disable-nls

NOTES:
compile AS
	m68k-elf-as -m68000 -Iinc -o test.o

link LD
	m68k-elf-ld --oformat=binary -Ttext=0 [--verbose] --output=outfile [infiles]

DISCLAIMER
----------
This project is primarily a personal one to sharpen assembly coding skills as well as to familiarize myself with Megadrive hardware and development. Things probably won't be 100% optimal.

