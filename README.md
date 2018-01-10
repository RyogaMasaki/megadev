#MegaDev
A very minimal Sega Megadrive development framework in M68000 assembly.

##DISCLAIMER - DO NOT USE THIS
This project is primarily a personal one to sharpen assembly coding skills as well as to familiarize myself with Megadrive hardware and development. Things are not complete and are certainly not optimal.

#Toolchain
The code is written for the GNU assembler (GAS) with the m68k-elf target. If you do not already have a toolchain setup, you'll need to compile Binutils and (optionally) GCC

##Toolchain setup
Binutils:
	./configure --prefix=$OPTDIR --target=m68k-elf

GCC:
	./configure --prefix=$OPTDIR --target=m68k-elf --enable-languages=c --disable-nls

