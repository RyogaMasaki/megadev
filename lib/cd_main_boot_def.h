/**
 * \file cd_main_boot_def.h
 * Boot ROM system call vector & memory definitions
 */

#ifndef MEGADEV__CD_MAIN_BOOT_DEF_H
#define MEGADEV__CD_MAIN_BOOT_DEF_H

/**
 * \defgroup boot_vdp Boot ROM VDP related functions
 * \defgroup boot_dma Boot ROM DMA related functions
 */
/**
 * The following are memory locations used by the Boot ROM subroutines
 * There is some conflicting information on whether these should be used as
 * the manuals say that memory above 0xfffd00 should not be used. However,
 * some of these locations are necessary in order to use the Boot ROM
 * subroutines. This has not yet been thoroughly tested across different
 * BIOS revisions.
 */

/**
 * \var _SPRITE_LIST
 * Sprite list RAM buffer
 * Size: 0x280
 */
#define _SPRITE_LIST      0xfff900

/**
 * \var _PALETTE
 * CRAM (palette) buffer
 * Size: 0x80
 */
#define _PALETTE 0xfffb80

/**
 * \var word _VDP_REGS
 * 
 * RAM buffer of all VDP registers (except DMA regs), making up 19 entries. 
 * You will need to keep these updated manually unless you use _VDP_REG_LOAD.
 * 
 * \ingroup boot_vdp
 */
#define _VDP_REGS  0xfffdb4

/**
 * \var _PLANE_WIDTH
 * Cached value of the plane width as defined in VDP reg. 0x10. 
 * This needs to be manually updated each time the register is changed!!
 * 
 * \ingroup boot_vdp
 */
#define _PLANE_WIDTH   0xFFFE2E

/**
 * The value added to each character byte when calling _PRINT_STRING. The font
 * can begin no earlier than tile index 0x20
 */
#define _FONT_TILE_BASE 0xFFFE2C

/**
 * \var word _RANDOM
 * Will contain a random number on each call to the PRNG
 */
#define _RANDOM

/**
 * This is used by the Boot ROM VINT/VINT_WAIT routines for graphics updates
 * during vblank.
 * Size: 8bit
 * 
 * Bit 0 - Copy sprite list to VDP
 * Bit 1 - Call VINT_EX vector during vblank
 */
/* 8 bit */
#define _VINT_FLAGS    0xfffe26

/**
 * Flags for \ref _VINT_FLAGS
 */
#define COPY_SPRLIST_BIT  0
#define CALL_VINT_EX_BIT  1

/**
 * Bitmasks for \ref _VINT_FLAGS
 */
#define COPY_SPRLIST_MSK  1 << COPY_SPRLIST_BIT
#define CALL_VINT_EX_MSK  1 << CALL_VINT_EX_BIT

/* 8 bit */
#define _GFX_REFRESH 0xfffe29

/* _GFX_UPD_FLAGS bits/masks */
#define CRAM_UPDATE_BIT 0

#define CRAM_UPDATE_MSK 1 << CRAM_UPDATE_BIT

/**
 * Skips extended operations during vblank - CRAM copy, sprite list copy,
 * increase vblank counter
 * Will still perform IO updates, though
 * Size: 8bit
 */
/* 8bit */
#define VBLANK_SKIP_GFX_UPDATE 0xfffe28

/*16 bit*/
#define _INPUT_P1 0xfffe20
/* 8 bit */
#define _INPUT_P1_HOLD 0xfffe20
#define _INPUT_P1_PRESS 0xfffe21

/*16 bit*/
#define _INPUT_P2 0xfffe22
/* 8 bit */
#define _INPUT_P2_HOLD 0xfffe22
#define _INPUT_P2_PRESS 0xfffe23

/**
 * _RESET
 * This is used as the default reset vector. Leads to Mega CD title screen.
 */
#define _RESET         0x000280

/**
 * _ENTRY
 * This is the Boot ROM entry. On cold boot, checks for TMSS, clears RAM, writes
 * Z80 driver, writes PSG data, then moves on to checking hardware region and
 * clearing VRAM. On warm boot, skips directly to region check, then jumps to
 * the reset vector. Leads to Mega CD title screen.
 */
#define _ENTRY         0x000284

/**
 * Sets default VDP regs, clears VRAM, sets default vectors, inits controllers,
 * loads Z80 data, transfers Sub CPU BIOS, loads CD player program
 */
#define _INIT          0x000288

/**
 * Same as above, but sets the stack pointer first.
 */
#define _INIT_SET_SP   0x00028C


/**
 * \fn _VINT
 * 
 * Vertical Blank interrupt handler. Copies GA comm registers to the RAM
 * mirrors, sends INT2 (VINT ocurred) to Sub CPU, updates VDP palette from
 * RAM, calls VINT_EX, updates IO (controllers).
 */
#define _VINT          0x000290

/*
 * There are two functions for setting the HINT vector. Both are almost
 * identical but for one minor difference: HINT2 will set the address in A1
 * to both the Main CPU vector and the Gate Array vector (GA_HINTVECT), while
 * HINT1 sets A1 to the Main vector but sets the GA vector to the address of
 * the Main vector, i.e. 0xFFFD0C. It's unclear what this difference entails.
 */

/**
 * \fn _SET_HINT1
 * \brief Sets the HINT vector
 * \param[in] A1.w HINT vector
 * 
 * Sets the HINT vector in the jump table and the Gate Array register
 * and enables the interrupt on the VDP. The VDP register buffer (_VDP_REGS) is
 * updated.
 * 
 * IN:
 *  a1.w - HINT vector
 * OUT:
 *  None
 * BREAK:
 *  None
 */
#define _SET_HINT1      0x000294

/**
 * \fn _UPDATE_INPUT
 * \brief Update state of P1/P2 controllers
 * \param[out] _INPUT_P1
 * \param[out] _INPUT_P2
 * 
 * \break d6-d7/a5-a6
 */
#define _UPDATE_INPUT  0x000298

/*
Still unsure exactly what this does. Reads inputs and filters for D-pad, then
adds/multiplies D7. As far as I can tell, the result will always be 0x0D in D7
*/
#define _UNKNOWN_07

/**
 * \fn _VDP_CLEAR_VRAM
 * \brief Clear all of VRAM and VSRAM
 * \break d0-d3/a6
 * 
 * \note This does not clear CRAM.
 */
#define _VDP_CLEAR_VRAM  0x0002A0

/**
 * \fn _VDP_CLEAR_NMTBL
 * \brief Clear nametables and sprite list
 * \break d0-d3/a6
 * \note This works only with the Boot ROM default VRAM layout
 */
#define _VDP_CLEAR_NMTBL 0x0002A4

/**
 * \fn _VDP_CLEAR_VSRAM
 * \brief Clear VSRAM
 * \break d0-d2
 */
#define _VDP_CLEAR_VSRAM 0x0002A8

/**
 * \fn _VDP_REG_LOAD_DEFAULTS
 * \brief Loads the Boot ROM default VDP register defaults
 */
#define _VDP_REG_LOAD_DEFAULTS  0x0002AC

/**
 * \fn _VDP_REG_LOAD
 * \brief Load values into multiple VDP registers
 * \param[in] A1.l Pointer to register data
 *  
 * \details Register data is an array of word sized values,
 * where the upper byte is the register ID
 * (e.g. 80, 81, etc) and the lower byte is
 * the value, with the list terminated by 0.
 */
#define _VDP_REG_LOAD  0x0002B0

/**
 * \fn _VDP_FILL
 * \brief Fill a region of VDP memory with a value
 * \param[in] D0.l Address (vdpaddr format)
 * \param[in] D1.w Length (in words)
 * \param[in] D2.w Value
 * \break d0-d2
 * 
 * \details This is a simple data transfer via the VDP data port rather than
 * DMA.
 */
#define _VDP_FILL  0x0002B4

/**
 * \fn _VDP_FILL_CLEAR
 * \brief Fill a region of VDP memory with 0
 * \param[in] D0.l Address (vdpaddr)
 * \param[in] D1.w Length (in words)
 * \break d0-d2
 * 
 * \details This is a simple data transfer via the VDP data port rather than DMA.
 */
#define _VDP_FILL_CLEAR  0x0002B8

/**
 * \fn _VDP_DMA_FILL_CLEAR
 * \brief Fill a region of VDP memory with zero
 * \param[in] D0.l Address (vdpaddr format)
 * \param[in] D1.w Length (in words)
 * \break d0-d3/a6
 */
#define _VDP_DMA_FILL_CLEAR  0x0002BC

/**
 * \fn _VDP_DMA_FILL
 * \brief Fill a region of VDP memory with a value
 * \param[in] D0.l Address (vdpaddr format)
 * \param[in] D1.w Length (in words)
 * \param[in] D2.w Value
 * \break d0-d3/a6
 */
#define _VDP_DMA_FILL  0x0002C0

/**
 * \fn _VDP_LOAD_MAP
 * \brief Fill a region of a nametable with map data
 * \param[in] D0.l VRAM Address (vdpaddr format)
 * \param[in] D1.w Map width
 * \param[in] D2.w Map height
 * \param[in] A1.l Pointer to map data
 * \break d0-d3/a1/a5
 * 
 * \details The map data should be an array of word values in the standard
 * nametable entry format.
 */
#define _VDP_LOAD_MAP  0x0002C4

/**
 * \fn _VDP_LOAD_MAP_TEMPLATE
 * \brief Fill a region of a nametable with map data
 * \param[in] D0.l VRAM address (vdpaddr format)
 * \param[in] D1.w Map width
 * \param[in] D2.w Map height
 * \param[in] d3.w Template
 * \param[in] A1.l Pointer to map data
 * \break d0-d3/a1/a5
 * 
 * \details This is very similar to _VDP_LOAD_MAP, however, the input map data is made
 * up of only single bytes. The value is placed in the lower byte of D3, and
 * the word value is placed in the nametable. Since D3 is not cleared 
 * beforehand, the upper byte of the word can be set before calling, making it
 * a "template" that applies to each tile.
 */
#define _VDP_LOAD_MAP_TEMPLATE  0x0002C8

/**
 * \fn _VDP_LOAD_MAP_CONST
 * \brief Fill a region of a nametable with a value
 * \param[in] D0.l Address (vdpaddr format)
 * \param[in] D1.w Width
 * \param[in] D2.w Height
 * \param[in] D3.w Value
 * \break d0-d3/d5/a5
 */
#define _VDP_LOAD_MAP_CONST  0x0002CC

/**
 * \fn _VDP_DMA_XFER
 * \brief Performs a data transfer to VRAM via DMA
 * \param[in] D0.l VRAM destination address (vdpaddr format)
 * \param[in] D1.l Source address
 * \param[in] D2.w Length (in words)
 * \break d0-d3/a6
 */
#define _VDP_DMA_XFER  0x0002D0

/**
 * \fn _VDP_DMA_WORDRAM_XFER
 * \brief Performs a data transfer from Word RAM to VRAM via DMA
 * \param[in] D0.l VRAM destination (vdpaddr format)
 * \param[in] D1.l Source address
 * \param[in] D2.w Length (in words)
 * \break d0-d3/a6
 * 
 * \details There is a well-documented issue with doing DMA from Word RAM to VRAM
 * which must be accounted for by writing the final word of data to the
 * data port. This subroutine takes care of that extra step.

 */
#define _VDP_DMA_WORDRAM_XFER  0x0002D4

/**
 * \fn _VDP_DISP_ENABLE
 * \brief Enable VDP output
 * 
 * \details Sets bit 6 on VDP reg. #1. The VDP register buffer is updated.
 */
#define _VDP_DISP_ENABLE 0x0002D8

/**
 * \fn _VDP_DISP_DISABLE
 * \brief Disable VDP output
 * 
 * \details Clears bit 6 on VDP reg. #1. The VDP register buffer is updated.
 */
#define _VDP_DISP_DISABLE 0x0002DC

/**
 * \fn _PAL_LOAD
 * \brief Load palette to RAM buffer
 * \param[in] A1.l Pointer to palette data structure
 * \break d0
 * 
 * \details The color palette is loaded but the "Palette Update" flag is not set
 */
#define _PAL_LOAD 0x0002E0

/**
 * \fn _PAL_LOAD_UPDATE
 * \brief Load palette to RAM buffer and set Palette Update flag
 * \param[in] A1.l Pointer to palette data structure
 * \break d0
 */
#define _PAL_LOAD_UPDATE 0x0002E4

/**
 * \fn _GFX_DECMP
 * \brief Decompress graphics data in the "Nemesis" format to VRAM
 * \param[in] A1.l Pointer to compressed data
 * \note You must set the destination on the VDP control port before calling
 * this routine!
 */
#define _GFX_DECMP      0x0002EC

/**
 * \fn _GFX_DECMP
 * \brief Decompress graphics data in the "Nemesis" format to RAM
 * \param[in] A1.l Pointer to compressed data
 * \param[in] A2.l Pointer to decompressed data buffer
 */
#define _GFX_DECMP_RAM    0x0002F0

/**
 * \fn _DISP_SPR_OBJ
 * \brief Update/display sprite objects
 * \param[in] A0.l Pointer to object array
 * \param[in] A1.l Pointer to sprite list buffer
 * \param[in] D0.w Number of objects
 * \param[in] D1.w Object size
 * \break d0-d4/d6/a2
 */
#define _DISP_SPR_OBJ    0x0002F4

/**
 * \fn _CLEAR_REGION
 * \brief Clear a region of memory
 * \param[in] A0.l Pointer to memory region
 * \param[in] D7.l Size to clear (in longs)
 * \break d6/a6
 */
#define _CLEAR_REGION    0x0002F8

/**
 * \fn _UNKNOWN_1F
 * 
 * Calls _CLEAR_REGION in a loop with d5 as the counter, but this may be buggy
 * since d7 should be down to 0 after the first iteration. Not sure what is
 * going on here...
 * 
 * IN:
 *  a0.l - Pointer to memory region
 *  d7.l - Size to clear (in longs)
 * OUT:
 *  None
 * BREAK:
 *  d6/a6
 */
#define _UNKNOWN_1F    0x0002FC

/**
 * \fn _DISP_SPR_STRUCT
 * \brief Display a sprite structure
 * \param[in] A0.l Pointer to parent sprite object
 * \param[in] D6.b Initial value for "next" sprite
 * \break d0-d4/a1-a2
 */
#define _DISP_SPR_STRUCT    0x000300

/**
 * \fn _VINT_WAIT
 * \brief Wait for vertical interrupt
 * \break d0
 * \note This will also make a call to _PRNG
 */
#define _VINT_WAIT          0x00304

/**
 * \fn _VINT_WAIT_DEFAULT
 * \brief Wait for vertical interrupt with default flags
 * \break d0
 * 
 * \details This will set the default VINT flags (copy sprite list & call VINT_EX)
 * before waiting for VINT
 * This will also make a call to _PRNG
 */
#define _VINT_WAIT_DEFAULT  0x000308

/**
 * \fn _COPY_SPRITE_LIST
 * \brief Copies sprite list buffer to VDP via DMA
 * \break d4/a4
 * 
 * \details This uses the default Boot ROM VRAM layout (i.e. sprite list at 0xB800)
 * Will only perform the copy of bit 0 of VINT_FLAGS is set (so this is likely
 * intended to be called from VINT, probably VINT_EX)
 */
#define _COPY_SPRITE_LIST  0x00030C

/**
 * \fn _UNKNOWN_24
 * 
 * A very small routine, but it's unclear what it would have been used for.
 * 
 * Manipulates d0 (bytes to long?) and copies to d1, swaps, upper word of d0
 * becomes outer loop, d1 inner loop, and copies long from a0 to a1 on each
 * iteration. After loop, jumps to a2.
 * 
 * IN:
 *  d0 - 
 *  a0 - Source data
 *  a1 - Dest data
 *  a2 - Ptr to jump after copy
 * OUT:
 *  None
 * BREAK:
 *  d1
 */
#define _UNKNOWN_24  0x000310

/**
 * \fn _SET_HINT2
 * \brief Sets the HINT vector in the jump table and points the Gate Array
 * register to the jump table entry, and enables the interrupt on the VDP.
 * \param[in] A1.w Pointer to HINT vector
 * 
 * \details The VDP register buffer (_VDP_REGS) is updated with this call.
 */
#define _SET_HINT2      0x000314

/**
 * \fn _DISABLE_HINT
 * \brief Disables horizontal interrupts on the VDP
 * 
 * \details The VDP register buffer (_VDP_REGS) is updated with this call.
 */
#define _DISABLE_HINT   0x000318

/**
 * \fn _PRINT_STRING
 * \brief Displays an ASCII string
 * \param[in] A1.l Pointer to string
 * \param[in] D0.l VRAM destination (vdpaddr)
 * \break d1-d2/a5
 * 
 * \details  
 * Strings are terminated with 0xFF and use 0x00 for newline.
 * The value in _FONT_TILE_BASE is added to each character byte, but no other
 * transformations are done. This means that the font must begin at index 0x20
 * at the earliest (where _FONT_TILE_BASE is 0).
 * Note that this can only use palette line 0.
 */
#define _PRINT_STRING   0x00031C


/**
 * \fn _LOAD_1BPP_TILES
 * \brief Displays an ASCII string
 * \param[in] A1.l Pointer to 1bpp graphics data
 * \param[in] D0.l VRAM destination (VDPADDR)
 * \param[in] D1.l Color bit map
 * \param[in] D2.l Tile count
 * \break d3-d4/a5
 * 
 * \details
 * The color bit map value is a long that must be in this format:
 * BB'BF'FB'FF
 * Where B and F are indices on the first coloe palette. B represents the back
 * ground color and F the foreground.
 * For example, to have your 1bpp graphics use palette index 2 for the "main"
 * color and a blank background (index 0), then put 00022022 in d1.
 */
#define _LOAD_1BPP_TILES   0x000320

/**
 * \fn _LOAD_FONT
 * \brief Load the internal 1bpp ASCII font
 * \param[in] D0.l VRAM destination (VDPADDR)
 * \param[in] D1.l Color bit map
 * \break d2-d4/a1/a5
 * 
 * \details
 * See the notes in _LOAD_1BPP_TILES for more info about the color bit map.
 * The VRAM destination should place the font no earlier than tile index
 * 0x20 if you are planning to use this with the _PRINT_STRING function.
 */
#define _LOAD_FONT   0x000324

/**
 * \fn _LOAD_FONT_DEFAULTS
 * \brief Load the internal 1bpp ASCII font with default settings
 * \break d0-d4/a1/a5
 * 
 * \details
 * This will place the tiles starting at index 0x20, making it compatible with
 * _PRINT_STRING, and sets the font color to index 1.
 */
#define _LOAD_FONT_DEFAULTS   0x000328

/**
 * \fn _DPAD_DELAY
 * \brief Generates a brief delay after initially pressing the D-pad
 * \param[in] A1.l Pointer to byte which will hold the output D-pad value
 * \param[in] D0.w If 0, use P1 input; if non-zero, use P2 input
 * \break d1/a1/a5
 * 
 * \details
 * This is useful for working with cursors on menus as it creates a brief
 * pause when holding a D-pad direction. You'll need to test against the
 * output variable (set in a1) rather than the standard input mirror in order
 * to use this correctly.
 */
#define _DPAD_DELAY   0x00032C

/**
 * \fn _MAP_DECOMP
 * \brief Decompress Enigma data
 * \param[in] D0.w Start tile index
 * \param[in] A1.l Pointer to Enigma compressed data
 * \param[in] A2.l Pointer to output buffer
 */
#define _MAP_DECOMP   0x000330

/**
 * \fn _LOAD_MAP_VERT
 * \brief Load map for a vertically-oriented contiguous group of tiles
 * \param[in] D0.l Destination address (vdpaddr)
 * \param[in] D1.w Map width
 * \param[in] D2.w Map height
 * \param[in] D3.w Starting tile index (plane pattern format)
 * \break d4-d6/a5
 */
#define _LOAD_MAP_VERT   0x000334

/**
 * \fn _PRNG_MOD
 * \brief Generate a new random number limited with the given modulo
 * \param[in] D0.w Modulo
 * \param[out] D0.w Random number between 0 and modulo
 * \break d1
 * 
 * \details The number will be stored in d0
 */
#define _PRNG_MOD   0x000338

/**
 * \fn _PRNG
 * \brief Generate a new random number
 * \break d0
 * 
 * \details The number will be stored in _RANDOM.
 */
#define _PRNG   0x00033C

/**
 * \fn _CLEAR_COMM_REGS
 * \brief Clears all Gate Array communication registers
 * \break d0/a6
 * 
 * \details This clears the COMFLAGS and COMCMD registers directly as well as
 * their RAM buffers
 */
#define _CLEAR_COMM_REGS   0x000340

/**
 * \fn _TRIGGER_IFL2
 * \brief Send INT 2 to Sub CPU
 * \break a5
 */
#define _TRIGGER_IFL2   0x000360

/**
 * \fn _SEGA_LOGO
 * \brief Run the Sega logo startup code
 * 
 * \note This should never need to be called from inside the game. It is
 * called automatically as part of the security code during startup and is
 * included here only for reference.
 */
#define _SEGA_LOGO   0x000364

/**
 * \fn _SET_VINT
 * \brief Set a new VINT subroutine
 * \param[in] A1.l Pointed to VINT subroutinte
 * 
 * \note Honestly, this is relatively useless as a subroutine. It simply moves
 * the adddress into _mlevel6+2. You may as well do the move yourself and skip
 * the stack push/extra cycles from the jsr.
 */
#define _SET_VINT   0x000368

/**
 * \fn _LOAD_TILEMAP_SEQ
 * \brief Loads a horizontally oriented sequential tilemap
 * \param[in] D0.l Destination VRAM address (vdpaddr)
 * \param[in] D1.w Map width
 * \param[in] D2.w Map height
 * \param[in] D3.w Initial pattern
 * \break d4/a5
 */
#define _LOAD_TILEMAP_SEQ   0x00036C

/**
 * \fn _UKNOWN_3B
 * 
 * This is related to loading tilemaps to VRAM and is similar to 
 * _LOAD_TILEMAP_SEQ, however it reads map data from a pointer and does some
 * odd calculation on D3, subtracting the width twice and then subtracting 2.
 * The value in D3 is added to the A1 pointer at the end of each row.
 * It's not clear what sort of value D3 is meant to have to start with and
 * it's not clear what exactly this routine is meant to do.
 * 
 * IN:
 *  d0.l - Destination vdpaddr
 *  d1.w - Map width
 *  d2.w - Map height
 *  d3.w - ?
 *  a1.l - Pointer to pattern data
 * OUT:
 *  None
 * BREAK:
 *  d4/a5
 */
#define _UKNOWN_3B   0x000370

/**
 * \fn _VDP_DMA_COPY
 * \brief Copy data within VRAM via DMA
 * \param[in] D0.l Destination VRAM address (vdpaddr)
 * \param[in] D1.w Source VRAM address
 * \param[in] D2.w Length
 * \break d3/a6
 */
#define _VDP_DMA_COPY  0x000374

#define _UNKNOWN_3D  0x000378

/**
 * \fn _CONVERT_BCD_BYTE
 * \brief Convert a byte value to BCD
 * \param[in] D1.b Hex value
 * \param[out] D1.b BCD value
 */
#define _CONVERT_BCD_BYTE  0x00037C

/**
 * \fn _CONVERT_BCD
 * \brief Convert a word value to BCD
 * \param[in] D1.w Hex value
 * \param[out] D1.w BCD value
 */
#define _CONVERT_BCD  0x000380

/**
 * \fn _BLANK_DISPLAY
 * \brief Blanks the display
 * 
 * \details This routine clears palette index 0 (black) and disables VDP output.
 * \note The VDP register buffer will be updated
 */
#define _BLANK_DISPLAY  0x000384

/**
 * \fn _PAL_FADEOUT
 * \brief Fade a range of the color palette to black
 * \param[in] D0.w Palette index (*byte* offset, not word!)
 * \param[in] D1.w Length (In *words*, not bytes!)
 * \param[out] Z Palette complete
 * 
 * \details If Z is not set, the palette fade process is not yet complete
 * and subroutine should be called against next loop.
 * 
 * \note Sets the palette update flag on _GFX_REFRESH
 */
#define _PAL_FADEOUT  0x000388

/**
 * \fn _PAL_FADEIN
 * \brief Fade a range of the color palette from black
 * \param[out] Z Palette complete
 * 
 * \details If Z is not set, the palette fade process is not yet complete
 * and subroutine should be called against next loop.
 * 
 * \note _SET_FADEIN_TARGET should be called first to set up the input values.
 * \note Sets the palette update flag on _GFX_REFRESH
 */
#define _PAL_FADEIN  0x00038C

/**
 * \fn _SET_FADEIN_TARGET
 * \brief Sets the target color palette for a fadein
 * \param[in] A1.l Pointer to target palette structure
 */
#define _SET_FADEIN_TARGET  0x000390

/**
 * \fn _DMA_XFER_QUEUE
 * \brief Transfer queued VDP bound data via DMA
 * \param[in] A1.l Pointer to queue entry array
 * 
 * \details The queue is an array of DMA transfer entries in this format:
 *     0.w Data length
 *     2.l Destination (vdpaddr)
 *     6.l Source address
 * The list should be terminated with a 0 word. Note that this system is
 * extremely basic and does not account for DMA bandwidth, etc. Moreover, no
 * array management is done and the list will need to be cleared by the user.
 */
#define _DMA_XFER_QUEUE  0x000394

#define _UNKNOWN_44 0x000398

#define _UNKNOWN_45 0x00039C

#define _UNKNOWN_46 0x0003A0

/*
VDP layout for Boot ROM

0xb800 - sprite list?
0xa000 (size 0xE00)
0xc000 (size 0x2000)
0xe000 (size 0x2000)

*/

#endif

