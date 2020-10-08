# MEGADEV
*HIGH GRADE MULTIPURPOSE USE*

A lightweight Sega Mega Drive and Mega CD development framework. Useful as boilerplate for a new project.

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

## Default directory structure
```dist```

Final built binaries

```build```

Compilation work directory

```etc```

Contains miscellaneous files that will not be incorporated into the final binaries

```res```

Contains resources (graphics, sound, etc) that will be incorporated into the final binaries

```md_src```

Source code for Mega Drive program

```cd_src```

Source code for Mega CD program

```lib```

MEGADEV libraries and C headers

```cfg```

Linker scripts

```tools```

Build utilities

## System Font
This distribution includes the [Saikyo Sans font by usr_share at OpenGameArt](https://opengameart.org/content/the-collection-of-8-bit-fonts-for-grafx2-r2).
