# Megadev Modules
Modules are a self-contained program, similar to a very small ROM. It contains both program code and data and can represent one piece of the whole of your project. For example, the title screen may be a module, the options screen a module, one stage a module, and so one.

Modules are a core part of Megadev and define how your code is built. A module is created from a .def file, which is simply a text file with a filename on each line. Each entry should be a code or resource file, which are all compiled seperately then linked together to make the module binary.

Be sure to check the `mod_load` project within the examples directory to see this in practice.

## Modules in detail
Megadev uses MMD format modules which originate from Sonic CD. These are program/resource binaries with a 0x100 byte header containing the following information:
  0x00.w Flags
	0x02.l Runtime location
	0x06.w Module size (in longs)
  0x08.l Pointer to main routine
	0x0C.l Pointer to HINT handler
	0x10.l Pointer to VINT handler

The most important entry here is the pointer to the main routine. After the module is loaded and set up, the code will jump (not call) to this routine. You can also specify a new HINT/VINT handler to be installed before the jump to main. The interrupt handlers are optional. The main routine is specified by a global function called `main` in your code, while the handlers are specified by global functions called `hint` and `vint`.

The runtime location specifies the address from which the code should be executed. Therefore, the MMD loader will first copy the binary portion of the module to this address before calling main. If this value is zero, the code will not be moved and will execute "as-is." This destination address is specified by a global symbol called MMD_DEST.

The module size is the size of the binary portion of the module, that is, the size of the module without the header. This value will be automatically calculated by the link script.

There is only one bit in the flags value, bit #6, which will return Word RAM control to the Sub CPU before jumping to main. (This appears to be the only bit used by Sonic CD.) You are free to use the rest of the bits as you wish, but we may associate additional functions to the lower bits of the word someday, if necessary. The flags are specified by a global symbol called MMD_FLAGS. Specifying the flags is optional.

This is followed by padding up to offset 0x100. This is not strictly necessary and we only do so because that's what Sonic CD does. You are free to extend into it with your own metadata (or hidden "easter egg" text). You can reduce or remove it entirely if you wish, but you will need to modify the MMD loader code (in mmd_exec_main.s) to account for the start of the module's binary section.

In other words, you must specify an entry point by having a global function called `main` and you must specify a runtime address with a global symbol called MMD_DEST. You can also optionally specify a new HINT/VINT handler by having a global function called `hint` and `vint` respectively within your code, and can also optionally specify the flags with a global symbol called MMD_FLAGS.

(As a side note, there doesn't seem to be a way to manually define a symbol (i.e. a named memory address) in C. You will need to specify this in asm using .equ/.global.)

Let's look at a couple theoretical examples. Let's say have a module we want to run from Main side's Work RAM. We have a memory resident bit of code in Work RAM taking up 0x400 bytes, so we want this module to run from 0xFF0400. The runtime location, then, is 0xFF0400. The MMD loader will automatically move the binary portion of the module from Word RAM to 0xFF0400.

Another example. We want the module to run from Word RAM this time. The Sub CPU loads it to... well, Word RAM. So there's really no reason to move it anywhere. We set the runtime location to 0, and it will not be moved anywhere.

## Memory Layout
We'll take a slight detour here. As we mentioned in the readme:

The memory layout of a standard Mega Drive cartridge game is relatively simple, with a large contiguous block of address space (32 Megabits!) available for the program. Things are not so simple with the Mega CD, however. We have three seperate memory blocks (Word RAM, PRG RAM and Work RAM), all of which are extremely small in comparison (2, 4, and 0.5 Megabits, respectively).

So we have three blocks of memory into which we can load data and execute programs. Each block is essentially an open "field" with no lines indicating what section is read-only program code and data and what is RAM or heap/stack space. Therefore we need to plan out that memory layout manually.

Although each block is made up of writable memory, it's helpful to use the analogy of "ROM" for read-only program/data space and "RAM" for writable storage. So based on what our module will be doing, we need to determine how much space to allot to ROM and to RAM.

Maybe this module we have lots of graphics data to be loaded to the VDP, but doesn't have much logic. It will need lots of ROM space but not much RAM. Or maybe this module will have actual gameplay. It will need a fair bit more RAM to keep track the game state.

In Megadev, we can specify which memory block the module data should be put in as well delineate ROM/RAM layout with some global symbols.

## Building modules
In either of the above examples, the module needs to be built to run from the expected memory block. If we want it to run in Work RAM, we need to tell the linker that (as per the above examples) we're running code from 0xFF0400 or from Word RAM that the code begins at 0x200100, right after the MMD header at `main`. Normally we would need a variety of different link scrips to do this, but in the interest of trying to keep things generic/simple, Megadev has a system of using global symbols to make the link script more dynamic.

Although all of runtime memory (Work RAM, Word RAM, PRG-RAM) is writable, 

Notes:
-An MMD must have the following defined:
 MODULE_ROM_ORIGIN, MODULE_ROM_LENGTH
	This defines the block of memory available to the program and its resources. This is NOT the size of the module's code/resources, but rather the size of the entire block
 MODULE_RAM_ORIGIN, MODULE_RAM_LENGTH
  Same as above, but for the data section (RAM)
 MMD_DEST
  
-An MMD requires a global function called main, which will be the entry point
-You can specify code in section .main to have it appear at the beginnig of the binary. This does not actually have to be the main function though.

## AP Memory Layout
Unlike a cartridge based system like the original Mega Drive, program data and resources are more transient. Files are loaded from disc to writable memory, and the "read-only" aspect is lost. Therefore, it is necessary to plan the memory layout of our program. Specifically, we need to define what part of our user memory works as program/resource storage and what part is RAM.

This is especially true on the Main side, which only has the 64kb of Work RAM dedicated to it. How this memory is used is further constrained by whether or not you plan to use the Boot ROM functions (see `bootrom.md`).

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

The System Use area, beginning at 0xFFFD00, contains the jump table for the exceptions/interrupts. The vector table created at startup is hardcoded to point to these locations and cannot be changed. In general, this area from 0xFFFD00 to the end of Work RAM is considered to be off-limits. In reality, however, the jump table only takes up 168 bytes, leaving the space from 0xFFFDA8 and onward free for use (600 bytes). If you're sure that's enough space for your stack, you could safely repoint it to 0 (as it is with the original Mega Drive). Compare that to the Boot ROM layout in the next section, which allocates only 256 bytes for its stack. Otherwise, it could be used as general RAM, or to hold a resident program/resource.

Outside of the System Use area, you have 63.25kb (64,768 bytes) of space to be divided up into blocks for program/resource, RAM, and stack. The program/resource block, which is analogous to the classic idea of ROM, is setup by the MODULE_ROM_ORIGIN and MODULE_ROM_LENGTH definition. Similarly, the RAM block is setup with the MODULE_RAM_ORIGIN and MODULE_RAM_LENGTH definitions. The ORIGIN definitions are hardware absolute addresses.

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

GLOBAL MODULE_ROM_ORIGIN, 0xFF0000
GLOBAL MODULE_ROM_LENGTH, 0xF000
GLOBAL MODULE_RAM_ORIGIN, 0xFFF000
GLOBAL MODULE_RAM_LENGTH, 0xB00

Keep in mind that the layout is not required to be static and can be changed in different modules.

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

You can, of course, move the stack to within the IP/AP Use area (your ROM space), but you will have to balance that with the size of your "ROM" (code/resources) and RAM usage.

## 

## Memory Resident Programs
It may be more efficient to keep a portion of program code or resources in memory even as you load different modules. For example, You can keep your small loading screen code/graphics in memory so it itself does not need to be loaded. Or you can keep some useful global functions that are available to all your code, such as VDP utilities. Sonic CD does this by loading an extended IP (IPX) into Work RAM which acts as a small "master" program to load and run modules from Word RAM.

Megadev supports this architecture. In your DEF f

## Pitfalls of running code in Word RAM
Though the Mega CD manuals describe Word RAM as primarily for data exchange between Sub and Main, you can run code from here with no problem. Sonic CD does this with its module architecture.

However, keep in mind that there may be unforeseen issues with this, primarily with interrupt handlers. Consider what happens if you set your VBLANK handler inside your module running in Word RAM, and then you go to load another module. What happens when you grant the Word RAM back to the Sub CPU, but your VINT is still pointing to that function in Word RAM? It's now no longer accessible, resulting in the VINT call failing and the Sub CPU not receiving INT2 (at best) or a straight up crash (at worst).

For that reason, make sure you assign any interrupt handlers to a place in Work RAM temporarily
