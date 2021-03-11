# Boot ROM


However, as we stated before, we do not have any official documentation on these calls (if it ever existed), so all our knowledge is based on reverse engineering. As such, there are a small handful of calls that are still not quite fully understood. We have named these as UNKNOWN along with a number. Anyone who can provide insight into them is certainly welcome to open a PR.

The plus side of using the Boot ROM routines is that they free up precious program and memory space for your game. You don't have to worry about certain function being loaded since they are always present, and user-space RAM that would be allocated for e.g. VDP register or sprite list cache is now available in the system-space RAM.

On the other hand, many of these functions are interrelated and can't be used independent of others. You will need to take a close look at the calls available and design your program architecture around the functionality you wish to use.

Please see the `cd_main_boot_def.h` file for the full list of functions.

### System Defaults
VDP regs, VRAM layout

### VDP Reg Array

### Palette Struct

### Sprite Objects

### Graphics Flags

### VINT_EX

### VINT Flags

### DMA Queue

### Internal Font & String Format
The  color bit map value is a long where each of the four bytes represents one of the possible two pixel pairs within each two bits of 1bpp data. The bit map is always structured like so:
00'0X'X0'XX
Where X is the palette index. All X values should be the same for a single-colored font. So if you want the font to use palette index 2, you would pass:
0x00022022
As the color bit map value.

If you want to understand "why" this value is necessary and formatted like it is, here is the algorithm in summary. Since the native VDP tile format is 4bpp, that means there are four bytes per tile row (8 pixels * 4 bits = 32 bits = 8 bytes). For 1bpp data, there is one byte per tile row. For every byte of 1bpp data, it rotates the value by 2 bits and masks those off. That 2 bit value is then used as a byte offset relative to the MSB of the font color bit map, which contains an equivalent 4bpp 2 pixel representation of that value. For example, 2 bits of 1bpp data = binary 10 (decimal 2). Two bytes offset from the MSB of the font color bit map is X0, which is appended to the output 4bpp data.
