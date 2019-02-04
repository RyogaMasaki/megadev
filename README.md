# MegaDev
A very minimal Sega Megadrive development framework in M68000 assembly.

## DISCLAIMER - DO NOT USE THIS
This project is primarily a personal one to sharpen assembly coding skills as well as to familiarize myself with Megadrive hardware and development. Things are not complete and are certainly not optimal.

# Toolchain
The code is written for the GNU assembler (GAS) with the m68k-elf target. If you do not already have a toolchain setup, you'll need to compile Binutils and (optionally) GCC

## Toolchain setup
If you're using Arch Linux, an M68k cross compiler is available in the AUR. At the minimum, you will need binutils for the assembler and linker:
https://aur.archlinux.org/packages/m68k-elf-binutils/

You will also want gcc if you plan to use C:
https://aur.archlinux.org/packages/m68k-elf-gcc-bootstrap/
