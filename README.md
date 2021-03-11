# MEGADEV
*AV INTELLIGENT TERMINAL WITH OPTICAL DISC DRIVE - HIGH GRADE MULTIPURPOSE USE*

A Sega Mega CD development framework available in C or assembly.

## /!\ WORK IN PROGRESS /!\
This project has not had extensive testing outside of the developer's personal projects. It's quite likely and almost certain that there are bugs throughout. It is also well understood that it is not quite user friendly yet and there are inconsistencies in naming choices and usage throughout. However, as this is just a hobby project with no organizational support, it's better to get it out to the public as-is at this point and welcome any and all community feedback and fixes.

Feel free to direct any questions or feedback to @suddendesu on twitter or via github.

## Build Environment & Toolchain
The code is written for use with GNU development tools built with the m68k-elf target. At a minimum, you will need binutils for the assembler and linker. Optionally, you can install gcc for programming in C and gdb for debugging.

It is also assumed to be running in a *nix environment. Theoretically, it should work in something like e.g. Cygwin, but this has not been tested.

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

## Getting Started
Clone the repo and place it in a location such as /opt/megadev. In the root of the directory is `megadev_global` which is a partial makefile. This is the global makefile. Edit it as necessary to match your build environment.

To start a new project copy the `makefile` file (the project makefile) into your project root directory and edit it as needed. You'll also probably want to pull one of the examples in the `examples` subdirectory and use it as a project skeleton. You can then do `make init` to create the work directories and begin coding!

If you have not already done so, you'll definitely need to familiarize yourself with the official Mega CD documentation.

## Building
The project can be built with the `make` command in the root of your project. You can check the global makefile for some more specific make targets.

Files to be put on the iso will be placed in the `disc` subdirectory (or whatever value you set in the project makefile). You can manually place whatever additional files you'd like into this directory and they will be included in the final ISO image.

## Including files
Be sure to add `$(megadev_path)/lib` to the include path of your IDE or project configuration.

Within the `lib` directory are the definitions, wrappers and source code for Megadev. In general, code is "assembly first" with C wrappers around asm calls. In order to facilitate the mixture of C/asm in projects, all memory addresses, registers, and other compile-time constants use C-style `#define` macros. Any files in the lib directory ending in `_def` contains such definitions and can be `#include`d in either C or asm source.

For asm source, files ending in `_macros` contain macros, as the name suggests. Because these and `_def` files do not contain immediate code, they can be `#include`d at the top of your source file without issue.

## CD Audio
Note that an ISO is *not* a complete disc image! An ISO is an image of a ISO9660 file system only. CD audio (also called CDDA) is seperate from the file system. If you wish to use CDDA in your project, you will need a CUE file to specify the table of contents (TOC) on the disc. You will find an example CUE file within the etc subdirectory of the project which can be copied and modified as necessary for your project. When loading the game in an emulator or preparing to burn, be sure to specify the CUE file as opposed to the ISO.

# Megadev Main Concepts & Functionality
Megadev provides three main areas of functionality: Modules, CD-ROM Access and System ROM Mappings.

## Modules
The memory layout of a standard Mega Drive cartridge game is relatively simple, with a large contiguous block of address space (32 Megabits!) available for the program. Things are not so simple with the Mega CD, however. We have three seperate memory blocks (Word RAM, PRG RAM and Work RAM), all of which are extremely small in comparison (2, 4, and 0.5 Megabits, respectively).

The tradeoff is that the Compact Disc can contain many hundreds of megabits of data, but how each block of available memory is used during runtime is one of the fundamental pieces of your program architecture. Even with a solid memory map in hand, actually building your code to run at certain offsets and to do so efficiently can become very complicated, very quickly.

Modules attempt to make things a little bit easier by providing a somewhat "generic" system for building code and including data in files. You can think of modules as very small "ROMs" on the disc. This is how most Mega CD games work: the title screen is a module, the options screen is a module, each stage is a module, and so on. It is one self-contained piece of the game as a whole.

The system was heavily inspired by Sonic CD and implements the game's module format (MMD). In fact, you can load and run some of the more simple MMD files on the game's disc as-is!

This is probably the most central concept of Megadev and having an understanding of how to create modules is necessary for creating games. See `modules.md` for more information.

## CD-ROM Access Wrapper
Using only the built-in Mega CD BIOS calls to retrieve data from the CD-ROM is a rather arduous process of specifying a sector offset, waiting for a number of sectors to be read, monitoring the CDC as it processes the input, and then finally having the data appear in a buffer. Megadev provides an API that wraps all this up so that only a filename and an output address are required.

This is not a required component of Megadev and you are free to write your own loading routines, but if you'd like to use it, see `cdrom.md` for more information.

## System ROM Mappings
The Mega CD is equipped with an internal ROM containing the CD player and backup RAM manager programs as well as a library of functions available to user programs (i.e. games). This internal ROM is split into two parts: the Boot ROM which runs on the Main CPU and the BIOS which runs on the Sub CPU. These user libraries are extremely useful and, in the case the BIOS, necessary for using the hardware.

The Sub CPU side BIOS code is well-documented with the official documentation from Sega. The system calls deal with disc access, CD audio playback, backup RAM access and other aspects of the Mega CD-specific hardware. Megadev provides definition files for these calls as well as C wrappers.

The Main CPU side Boot ROM code, however, is not well documented. It is actually somewhat of a mystery. Within the Boot ROM is an array of functions that are linked at a jump table, indicating they are meant to be used across ROM revisions and thus intended for use by games. While it seems most games do not make use of these system calls, at least some do (Keio Yuugekitai is one such game). This is solid evidence that the calls can be freely used by developers if they wish.

We do not have any official documentation on the Boot ROM. It is possible there never was such documentation to begin with, as we have three different source of Mega CD paperwork, most of which is wholly redundant, yet there is no sign of Boot ROM documentation. One of the later Technical Bulletins makes mention of these calls in passing and mentions they may be used by games, so it wasn't a secret. Its possible the documentation was never translated to English and was only available to Japanese developers.

In any case, there have been multiple attempts to reverse engineer the internal ROM on both CPUs and we now have a pretty good understanding of what sort of functions the Boot ROM provides. There are a number of useful tools for IO and VDP usage among other things. It also helps to free up precious RAM by allowing you to use memory that is reserved for these system functions. Megadev provides documentation, asm defines and C wrappers so you can take advantage of these tools in your code.

Using the Boot ROM functions is not required, but whether you choose to use it or not, we recommend you see `bootrom.md` as it also addresses important memory layout information.

# What's NOT present?
The Mega CD brought with it a wide array of new functions to the Mega Drive, and we have only supported a few of those. There is currently no support for PCM audio playback and, most notably, hardware graphics resizing/rotation.

Of course, by "support," we just mean there are currently no helper functions within Megadev for these abilities. Certainly, they can be used in your program by using the information within the official documentation. And of course we will be working to expand Megadev with more functionality in the future!
