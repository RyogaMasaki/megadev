# MegaDev
A very minimal Sega Megadrive development framework. Useful as boilerplate for a new project.

## DISCLAIMER - DO NOT USE THIS
This project is primarily a personal one to sharpen assembly coding skills as well as to familiarize myself with Megadrive hardware and development. Things are not complete and are certainly not optimal.

## Toolchain
The code is written for GNU M68k dev tools with the m68k-elf target. If you do not already have a toolchain setup, you'll need to compile as, binutils and (optionally) gcc, all with the m68k-elf target.

### Toolchain setup
If you're using Arch Linux, an M68k cross compiler is available in the AUR. At the minimum, you will need binutils for the assembler and linker:

https://aur.archlinux.org/packages/m68k-elf-binutils/

You will also want gcc if you plan to use C:

https://aur.archlinux.org/packages/m68k-elf-gcc-bootstrap/

## Building
The default makefile target will create a Megadrive compatible binary called 'out.md' in the bin directory.

There is also a an 'elf' target that will create an ELF binary suitable for debugging (e.g. with Blastem's GDB integration).

## Testing
The final binary can be tested in an emulator or on hardware. Here are a couple quick commands for reference to quickly test from the bin directory:

MAME:

```mame genesis -cart $(pwd)/out.md -debugger on```

Blastem:

```blastem -d out.md```

## Directory structure
```bin```

Contains built binaries

```etc```

Contains miscellaneous work files that will not be incorporated into the final ROM

```res```

Contains resources (graphics, sound, etc) that will be incorporated into the ROM

```src```

User application source code

```sys```

System/hardware source code and configurations

## Misc
This distribution includes the Saikyo Sans font by usr_share at OpenGameArt: https://opengameart.org/content/the-collection-of-8-bit-fonts-for-grafx2-r2
