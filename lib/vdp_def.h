/**
 * \file vdp_def.h
 * VDP hardware definitions for both C and asm sources
 */

#ifndef MEGADEV__VDP_DEF_H
#define MEGADEV__VDP_DEF_H

// VDP ports

/**
 * \var VDP_CTRL
 * \brief VDP control port
 * \details 16 bit wide - a 32 bit write is equivalent to two consecutive
 * 16 bit writes
 */
#define VDP_CTRL 0xC00004

/**
 * \var VDP_DATA
 * \brief VDP data port
 * \details 16 bit wide - a 32 bit write is equivalent to two consecutive
 * 16 bit writes
 */
#define VDP_DATA 0xC00000

/**
 * \var VDP_HVCOUNT
 * \brief HV Counter
 */
#define VDP_HVCOUNT 0xC00008

/**
 * \var VDP_DEBUG
 * \brief VDP debug port
 */
#define VDP_DEBUG 0xC0001C


// All VDP registers
/**
 * \var VDP_REG00
 * \brief Mode Register 1
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | ||L|IE1| |CM|M3|DE|
 *
 * \param L Blank leftmost 8 pixels to background color
 * \param IE1 Enable horizontal interrupts
 * \param CM 1 = normal 9-bit color mode (512 colour); 0 = low 3-bit color mode (8 colors)
 * \param M3 1 = freeze H/V counter on level 2 interrupt; 0 = enable H/V counter
 * \param DE 0 = enable display; 1 = disable display
 */
#define VDP_REG00 0x8000

/**
 * \def VDP_REG01
 * \brief Mode Register 2
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * |VR|DE|IE0|M1|M2|M5| ||
 *
 * \param VR Enable 128kB of VRAM (incompatible with standard consoles)
 * \param DE 1 = enable display; 0 = fill display with background colour
 * \param IE0 Enable vertical interrupts (VINT)
 * \param M1 1 = enable DMA operations; 0 = ignore DMA operations
 * \param M2 1 = 240 pixel (30 cell) PAL mode; 0 = 224 pixel (28 cell) NTSC mode
 * \param M5 1 = Mega Drive (mode 5) display; 0 = Master System (mode 4) display
 */
#define VDP_REG01 0x8100
 
/**
 * \def VDP_REG02
 * \brief Plane A Name Table VRAM Address
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | |PA6*|PA5|PA4|PA3| |||
 *
 * \param PA Bits 15-13 (PA5 to PA3) of Plane A nametable address in VRAM
  * 
 * /details The Plane A register address is effectively the full address (which
 * must be a multiple of 0x2000) divided by 0x400
 * /note PA6 is used with 12k VRAM only
 */
#define VDP_REG02 0x8200

/**
 * \def VDP_REG03
 * \brief Window Name Table VRAM Address
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | |W6|W5|W4|W3|W2|W1| |
 *
 * \param W Bits 15-11 (W5 to W1) of window nametable address in VRAM
 * 
 * \note The Window register address is effectively the full address (which
 * must be a multiple of 0x800) divided by 0x400
 * 
 * \note W1 is ignored in 40 cell mode, limiting the address to a multiple of
 * 0x1000
 * \note W6 is used with 128k VRAM only
 */
#define VDP_REG03 0x8300

/**
 * \def VDP_REG04
 * \brief Plane B Name Table VRAM Address
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | ||||PB3|PB2|PB1|PB0|
 *
 * \param PB Bits 15-13 (PB2 to PB0) of Plane B nametable address in VRAM
 * 
 * \note The Plane B register address is effectively the full address (which
 * must be a multiple of $2000) divided by $2000
 * \note PB3 is used with 128k VRAM only
 */
#define VDP_REG04 0x8400

/**
 * \def VDP_REG05
 * \brief Sprite Table VRAM Address
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * |ST7|ST6|ST5|ST4|ST3|ST2|ST1|ST0|
 *
 * \param ST Bits 15-9 (ST6 to ST0) of sprite table address in VRAM
 * 
 * \note The Sprite Table register address is effectively the full address
 *          (which must be a multiple of $200) divided by $200
 * \note ST0 is ignored in 40 cell mode, limiting the address to a multiple
 * of $400
 * \note ST7 is used with 128k VRAM only
 */
#define VDP_REG05 0x8500

/**
 * \def VDP_REG06
 * \brief Sprite Table VRAM Address (128k VRAM)
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | ||SP5||||||
 *
 * \param SP5 Bit 16 of Sprite Table address
 * 
 * \note SP5 is used with 128k VRAM only
 */
#define VDP_REG06 0x8600

/**
 * \def VDP_REG07
 * \brief Background Color
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | ||PL1|PL0|C3|C2|C1|C0|
 *
 * \param PL Palette line
 * \param C Palette index (color)
 */
#define VDP_REG07 0x8700

/**
 * \def VDP_REG08
 * \brief Unused
 * \details Master System horizontal scroll register
 */
#define VDP_REG08 0x8800

/**
 * \def VDP_REG09
 * \brief Unused
 * \details Master System vertical scroll register
 */
#define VDP_REG09 0x8900

/**
 * \def VDP_REG0A
 * \brief Horizontal Interrupt Counter
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * |H7|H6|H5|H4|H3|H2|H1|H0|
 *
 * \param H Number of scanlines between horizontal interrupts
 */
#define VDP_REG0A 0x8A00

/**
 * \def VDP_REG0B
 * \brief Mode Register 3
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | ||||IE2|VS|HS1|HS2|
 *
 * \param IE2 Enable external interrupts
 * \n 1: Enable
 * \n 0: Disable
 * \param VS Vertical scrolling mode
 * \n 1: 16 pixel columns (1 word per column in VSRAM)
 * \n 0: Full screen (1 long only in VSRAM)
 * \param HS Horizontal scrolling mode
 * \n 00: Full screen
 * \n 01: (Invalid)
 * \n 10: 8 pixel rows
 * \n 11: Single pixel rows
 */
#define VDP_REG0B 0x8B00

/**
 * \def VDP_REG0C
 * \brief Mode Register 4
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * |RS1|VSY|HSY|EP|SH|LS1|LS0|RS0|
 *
 * \param RS Screen width
 * \n 1: 40 cell mode (320 pixels)
 * \n 0: 32 cell mode (256 pixel width)
 * \n \em (Both RS0 and RS1 must be the same value.)
 * \param VSY Replace vertical sync signal with pixel bus clock
 * \param HSY (No documentation.)
 * \param EP Enable external pixel bus
 * \param SH Enable shadow/highlight mode
 * \param LS Interlace mode
 * \n 00: No interlace
 * \n 01: Interlace normal resolution
 * \n 10: No interlace
 * \n 11: Interlace double resolution
 */
#define VDP_REG0C 0x8C00

/**
 * \def VDP_REG0D
 * \brief Horizontal Scroll Data VRAM Address
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | |HS6|HS5|HS4|HS3|HS2|HS1|HS0|
 *
 * \param HS Bits 15-10 (HS5 to HS0) of horizontal scroll data address in VRAM
 * 
 * \note The Horiz Scroll Data register address is effectively the full address
 * (which must be a multiple of $400) divided by $400
 * \note HS6 is used with 128k VRAM only
 *
 */
#define VDP_REG0D 0x8D00

/**
 * \def VDP_REG0E
 * \brief Plane A/B Name Table VRAM Address (128k VRAM)
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | |||PB4| |||PA0|
 *
 * \param PB4 Bit 16 of Plane B nametable address
 * \param PA0 Bit 16 of Plane A nametable address
 * 
 * \note Both PB4 and PA0 are used with 128k VRAM only
 */
#define VDP_REG0E 0x8E00

/**
 * \def VDP_REG0F
 * \brief Auto-Increment Value
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * |INC7|INC6|INC5|INC4|INC3|INC2|INC1|INC0|
 *
 * \param INC Value to be added to the VDP address register after each
 * read/write to the data port
 * 
 * \note 2 is most common value in this register and many VDP related functions
 * assume that is the value in this register.
 */
#define VDP_REG0F 0x8F00

/**
 * \def VDP_REG10
 * \brief Plane Dimensions
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * | ||H1|H0| ||W1|W0|
 *
 * \param H Height setting for planes A & B
 * \n 00: 32 cells (256 pixels)
 * \n 01: 64 cells (512 pixels)
 * \n 10: (Invalid)
 * \n 11: 128 cells (1024 pixels)
 * \param W Width setting for planes A & B
 * \n 00: 32 cells (256 pixels)
 * \n 01: 64 cells (512 pixels)
 * \n 10: (Invalid)
 * \n 11: 128 cells (1024 pixels)
 * 
 * \note Height/width settings of 64x128 or 128x128 cells are invalid due to a
 * maximum plane size of $2000 bytes
 */
#define VDP_REG10 0x9000

/**
 * \def VDP_REG11
 * \brief Window Plane Horizontal Position
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * |R| ||HP4|HP3|HP2|HP1|HP0|
 *
 * \param R Window edge selection
 * \n 1: Draw window from HP to right edge of screen
 * \n 0: Draw window from HP to left edge of screen
 * \param HP Horizontal position on screen to start drawing the
 * window plane (in cells)
 */
#define VDP_REG11 0x9100

/**
 * \def VDP_REG12
 * \brief Window Plane Vertical Position
 * \details
 * | 7| 6| 5| 4| 3| 2| 1| 0|
 * |-:|-:|-:|-:|-:|-:|-:|-:|
 * |D| ||VP4|VP3|VP2|VP1|VP0|
 *
 * \param D Window edge selection
 * \n 1: Draw window from VP to bottom edge of screen
 * \n 0: Draw window from VP to top edge of screen
 * \param VP Vertical position on screen to start drawing the
 * window plane (in cells)
 */
#define VDP_REG12 0x9200

/**
 * \def VDP_REG13
 * \brief DMA Length (Low Byte)
 * \details
 * |   7|   6|   5|   4|   3|   2|   1|   0|
 * |----+----+----+----+----+----+----+----|
 * | L7 | L6 | L5 | L4 | L3 | L2 | L1 | L0 |
 *
 * L7-L0: Low byte of DMA length in bytes, divided by 2
 */
#define VDP_REG13 0x9300

/**
 * \def VDP_REG14
 * \brief DMA Length (High Byte)
 * \details
 * |   7|   6|   5|   4|   3|   2|   1|   0|
 * |----+----+----+----+----+----+----+----|
 * | H7 | H6 | H5 | H4 | H3 | H2 | H1 | H0 |
 *
 * H7-H0: High byte of DMA length in bytes, divided by 2
 */
#define VDP_REG14 0x9400

/**
 * \def VDP_REG15
 * \brief DMA Source (Low Byte)
 * \details
 * |   7|   6|   5|   4|   3|   2|   1|   0|
 * |----+----+----+----+----+----+----+----|
 * | L7 | L6 | L5 | L4 | L3 | L2 | L1 | L0 |
 *
 * L7-L0: Low byte of DMA source address, divided by 2
 */
#define VDP_REG15 0x9500

/**
 * \def VDP_REG16
 * \brief DMA Source (Mid Byte)
 * \details
 * |   7|   6|   5|   4|   3|   2|   1|   0|
 * |----+----+----+----+----+----+----+----|
 * | M7 | M6 | M5 | M4 | M3 | M2 | M1 | M0 |
 *
 * M7-M0: Middle byte of DMA source address, divided by 2
 */
#define VDP_REG16 0x9600

/**
 * \def VDP_REG17
 * \brief DMA Source (High Byte)
 * \details
 * |   7|   6|   5|   4|   3|   2|   1|   0|
 * |----+----+----+----+----+----+----+----|
 * | T1 | T0 | H5 | H4 | H3 | H2 | H1 | H0 |
 *
 * H5-H0: High byte of DMA source address, divided by 2
 * T1/T0: DMA type
 *        0x = 68k to VRAM copy
 *             (T0 is used as the highest bit in source address)
 *        10 = VRAM fill (source can be left blank)
 *        11 = VRAM to VRAM copy
 */
#define VDP_REG17 0x9700

// Convenience aliases to some useful registers

/**
 * Width/height of graphics planes
 */
#define VREG_PLANE_SZ VDP_REG10

/**
 * DMA length low byte (16 bit)
 */
#define VREG_DMA_SZ_LO VDP_REG13

/**
 * DMA length high byte (16 bit)
 */
#define VREG_DMA_SZ_HI VDP_REG14

/**
 * DMA source address low byte (22/23 bit)
 */
#define VREG_DMA_SRC_LO VDP_REG15

/**
 * DMA source address mid byte (22/23 bit)
 */
#define VREG_DMA_SRC_MD VDP_REG16

/**
 * DMA source address high byte (22/23 bit)
 *
 * If doing 68k -> VRAM transfer, bit 6 is used as the top bit of the source
 * address (23 bit source address)
 * If doing VRAM -> VRAM copy, both bits 6 and 7 must be set (22 bit source
 * address)
 */
#define VREG_DMA_SRC_HI VDP_REG17

// Status Register Bits
#define PAL_HARDWARE 0x0001
#define DMA_IN_PROGRESS 0x0002
#define HBLANK_IN_PROGRESS 0x0004
#define VBLANK_IN_PROGRESS 0x0008
#define ODD_FRAME 0x0010
#define SPR_COLLISION 0x0020
#define SPR_LIMIT 0x0040
#define VINT_TRIGGERED 0x0080
#define FIFO_FULL 0x0100
#define FIFO_EMPTY 0x0200

// VDP command/bus
// OR these values on to the vdpaddr formatted base address
#define VDP_VRAM_R   0x00000000
#define VDP_VRAM_W   0x40000000
#define VDP_CRAM_R   0x00000020
#define VDP_CRAM_W   0xC0000000
#define VDP_VSRAM_R  0x00000010
#define VDP_VSRAM_W  0x40000010

#endif
