# MegaDev
A very minimal Sega Megadrive development framework. Useful as boilerplate for a new project.

## DISCLAIMER - DO NOT USE THIS FOR SERIOUS PROJECTS
This project is still heavily work in progress. I would not recommend using it for any serious projects yet.


## Toolchain
The code is written for use with GNU development tools built with the m68k-elf target. At a minimum, you will need binutils for the assembler and linker. Optionally, you can install gcc for programming in C and gdb for debugging.

### Toolchain setup
Your distribution may have an M68k cross architecture binutils/gcc/gdb package in its repo; search there first.

If you're using Arch Linux, the tools are available in the AUR:
https://aur.archlinux.org/packages/m68k-elf-binutils/
https://aur.archlinux.org/packages/m68k-elf-gcc/
https://aur.archlinux.org/packages/m68k-elf-gdb/

If a prebuilt package is not available, you will need to build from source. Be sure to include ```--target=m68k-elf``` when running the configure script for each package.

You will need to configure the location and filenames of the tool binaries in the makefile.

### Manuals
GNU assembler (as): <https://sourceware.org/binutils/docs/as/index.html>
GNU linker (ld): <https://sourceware.org/binutils/docs/ld/index.html>
GNU debugger (gdb): <https://sourceware.org/gdb/current/onlinedocs/gdb/>
GNU compiler (gcc): <https://gcc.gnu.org/onlinedocs/gcc/>

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
### Byte definitions, .rodata and debug builds
GAS is a bit quirky when assembling with the -g/--gen-debug option. As such, if you plan to use ELF builds for debugging, the following rules should be kept in mind:

- The .rodata section should generally be placed before the .text section in each asm source file. As an exception, if it contains only .word or .long definitions, it can be placed anywhere (though it still needs the .section identifier, of course). However, if .byte or .incbin are used at all, it must appear before .text.
- For byte sized definitions (in .rodata or .data), use .byte instead of dc.b or ds.b. As a matter of consistency, it is strongly sugguest you use .word and .long instead of dc.w/dc.l (though they won't necessarily cause a problem).

If you get this error:

```Error: unaligned opcodes detected in executable segment```

while attempting to build a binary, double check your code against the rules above. If you don't plan on using debug builds at all, you can remove the 

### System Font
This distribution includes the [Saikyo Sans font by usr_share at OpenGameArt](https://opengameart.org/content/the-collection-of-8-bit-fonts-for-grafx2-r2).
