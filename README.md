# MEGADEV
*HIGH GRADE MULTIPURPOSE USE*

A lightweight Sega Mega CD development framework available in C or assembly.

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

## Development Concepts
There are two key concepts that Megadev revolves around: program modules and Mega CD Boot ROM calls.

The first is relatively simple: all code and resources for any individual section of a game is built into one file, a module, which is loaded from disc to either the Main or Sub CPU memory area. This is generally how all Mega CD games are designed. It's somewhat different from the modern development concept dividing code and content into seperate entities.

The second is specific to the Mega CD hardware. While the Mega Drive has no system library to call upon and everything must be written from scratch by the developer, the Mega CD has a large library of code for interacting with the disc, performing basic IO operations, VDP utilities, and so on. While most of these are officially documented (the BIOS, i.e. the Sub side library), there is a whole set of officially undocumented calls (the Boot ROM, i.e. the Main side library) which are available to users and were, indeed, used by some production games.

Rather than writing code from scratch, Megadev utilizes the built-in functionality of the Mega CD to perform many tasks. It provides asm definitions and C wrappers for most of these calls.

## Getting Started
Clone the repo and place it in a location such as /opt/megadev. In the root of the directory is `megadev_global` which is a partial makefile. Check this file and make any changes necessary to match your build environment.

To start a new project copy the `makefile` file into your project directory and edit it to suit your project. You can then do `make init` to create the work directories. You can then begin coding!

If you have not already done so, you'll definitely want to familiarize yourself with:
  - The Mega CD hardware via the official documentation
	- Megadev modules

## Building
`make`

## Boot ROM Functions


## Memory Concepts
Unlike a cartridge based system, like the original Mega Drive, program data and resources are more transient. Files are loaded from disc to writable memory, and the "read-only" aspect is lost. Therefore, it is necessary to plan the memory structure of our program. Specifically, we need to define what part of our user memory works as program/resource storage and what part is our RAM storage.

This is especially true on the Main side, which only has the 64kb of Work RAM dedicated to it. How this memory is used is further constrained by whether or not you plan to use the Boot ROM functions discussed above.

### Without Boot ROM Functionality
Without using the Boot ROM functions, the Work RAM map looks like this:

FF0000  +----------------+
        | IP/AP Use      |
        |                |
        |                |
        =                =
        |                |
        |                |
        |                |
        | Top of Stack   |
FFFD00  +----------------+
        | System Use     |
        |                |
FFFFFF  +----------------+

In this setup, the stack begins at 0xFFFD00. Recall that the stack works downwards, which you'll want to bear in mind when you decide what size to make your RAM block. You'll want to make sure the stack has enough space that it doesn't "bleed" down into a lower block.

The System Use area, beginning at 0xFFFD00, contains the jump table for the exceptions/interrupts. The vector table created at startup is hardcoded to point to these locations and cannot be changed. In general, this area from 0xFFFD00 to the end of Work RAM is considered to be off-limits. In reality, however, the jump table only takes up 168 bytes, leaving the space from 0xFFFDA8 and onward free for use (600 bytes). If you're sure that's enough space for your stack, you could safely repoint it to 0 (as it is with the original Mega Drive). Compare that to the Boot ROM layout in the next section, which allocates only 256 bytes for its stack. Otherwise, it could be used as general RAM, or hold a resident program/resource.

Outside of the System Use area, you have 63.25kb (64,768 bytes) of space to be divided up into blocks for program/resource usage, RAM, and stack. The program/resource block, which is analogous to the classic idea of ROM, is setup by the MMD_ROM_ORIGIN and MMD_ROM_SIZE definition. Similarly, the RAM block is setup with the MMD_RAM_ORIGIN and MMD_RAM_SIZE definitions. The ORIGIN definitions are hardware absolute addresses.

Here is an example setup:

FF0000  +----------------+
        | IP/AP Use      |
        | (i.e. ROM)     |
        | (0xF000 bytes) |
        |                |
        |                |
FFF000  +----------------+
        | RAM            |
        | (0xB00 bytes)  |
        |                |
FFFB00  +----------------+
        | Stack          |
        | (0x200 bytes)  |
FFFD00  +----------------+
        | System Use     |
        |                |
FFFFFF  +----------------+

To create this layout, we would define these values as such:

GLOBAL MMD_ROM_ORIGIN, 0xFF0000
GLOBAL MMD_ROM_SIZE, 0xF000
GLOBAL MMD_RAM_ORIGIN, 0xFFF000
GLOBAL MMD_RAM_SIZE, 0xB00

Keep in mind that the layout is not required to be static and can be tailored to meet the needs of the module.

### Using Boot ROM Functionality
The same general idea regarding partitioning memory as described above still applies when using Boot ROM functions, but the space available to us is much tighter. Here is the memory map when using the Boot ROM:


FF0000  +----------------+
        | IP/AP use      |
        |                |
        =                =
        |                |
        |                |
FFF700  +----------------+
        | Boot ROM Use   |
        |                |
FFFC00  +----------------+
        | Stack          |
FFFD00  +----------------+
        | System / Boot  |
        |       ROM Use  |
FFFFFF  +----------------+

Here, there is an additional 1,280 bytes used by the Boot ROM, from 0xFFF700 to 0xFFFC00, reducing our program use space to 61.75kb (63,232 bytes). Moreover, more of the previously free space in the System Use area is now taken up by several key Boot ROM components. The biggest problem, however, is the stack, which has only 256 bytes of space. Without carefully monitoring your code (especially if you are using C), it is very easy to overflow. (Immediately below the stack, at the top of the Boot ROM Use space, is the CRAM cache. If you start seeing incorrect colors on screen, especially on the fourth palette line, chances are you have a stack overflow.)

You can, of course, move the stack to within the IP/AP Use area (your ROM space), but you will have to balance that with the size of your code, resources and RAM usage.

## Modules
At a high level, you can think of modules as very small "ROMs" that are loaded from the CD and run. This is how most Mega CD games work: the title screen is a module, the options screen is a module, each stage is a module, and so on. It is one self-contained piece of the game as a whole.

Megadev is designed around this concept. qWe call these modules .mmd files as they are based on the mmd file concept used in Sonic CD, with minor modifications. An MMD can be configured to run from a specific location and includes options to prepare for its execution, such as specifying a new VINT/HINT handler.

A module is created from a .def file, which is simply a text file with a filename on each line. Each entry should be a code or resource file, which are all compiled seperately then linked together to make the module binary.



Notes:
-An MMD must have the following defined:
 MMD_ROM_ORIGIN, MMD_ROM_SIZE
	This defines the block of memory available to the program and its resources. This is NOT the size of the module's code/resources, but rather the size of the entire block
 MMD_RAM_ORIGIN, MMD_RAM_SIZE
  Same as above, but for the data section (RAM)
 MMD_DEST
  
-An MMD requires a global function called main, which will be the entry point
-You can specify code in section .main to have it appear at the beginnig of the binary. This does not actually have to be the main function though.
