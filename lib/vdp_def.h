/**
 * \file vdp_def.h
 * VDP hardware definitions for both C and asm sources
 */

#ifndef MEGADEV__VDP_DEF_H
#define MEGADEV__VDP_DEF_H

// VDP ports

/**
 * VDP control port
 * 16 bit wide - a 32 bit write is equivalent to two consecutive 16 bit writes
 */
#define VDP_CTRL 0xC00004

/**
 * VDP data port
 * 16 bit wide - a 32 bit write is equivalent to two consecutive 16 bit writes
 */
#define VDP_DATA 0xC00000

/**
 * HV Counter
 */
#define VDP_HVCOUNT 0xC00008

/**
 * VDP debug port
 */
#define VDP_DEBUG 0xC0001C


// All VDP registers
/**
 * \def VDP_REG00
 * \brief Mode Register 1
 * \details
 * |  7|  6|  5|    4|  3|   2|   1|   0|
 * |---+---+---+-----+---+----+----+----|
 * | 0 | 0 | L | IE1 | 0 | CM | M3 | DE |
 *
 * L: 1 = leftmost 8 pixels are blanked to background color
 * IE1: 1 = enable horizontal interrupts
 * CM: 1 = normal 9-bit color mode (512 colour)
 *     0 = low 3-bit color mode (8 colors)
 * M3: 1 = freeze H/V counter on level 2 interrupt
 *     0 = enable H/V counter
 * DE: 1 = disable display
 */
#define VDP_REG00 0x8000

/**
 * \def VDP_REG01
 * \brief Mode Register 2
 * \details
 * |   7|   6|    5|   4|   3|   2|  1|  0|
 * |----+----+-----+----+----+----+---+---|
 * | VR | DE | IE0 | M1 | M2 | M5 | 0 | 0 |
 *
 * VR: 1 = use 128kB of VRAM; not compatible with standard consoles with
 *         64kB VRAM
 * DE: 1 = enable display
 *     0 = fill display with background colour
 * IE0: 1 = enable vertical interrupts
 * M1: 1 = enable DMA operations
 *     0 = ignore DMA operations
 * M2: 1 = 240 pixel (30 cell) PAL mode
 *     0 = 224 pixel (28 cell) NTSC mode
 * M5: 1 = Mega Drive (mode 5) display
 *     0 = Master System (mode 4) display
 */
#define VDP_REG01 0x8100
 
/**
 * \def VDP_REG02
 * \brief Plane A Name Table VRAM Address
 * \details
 * |  7|    6|    5|    4|    3|  2|  1|  0|
 * |---+-----+-----+-----+-----+---+---+---|
 * | 0 | PA6 | PA5 | PA4 | PA3 | 0 | 0 | 0 |
 *
 * PA5-PA3: Bits 15-13 of Plane A nametable address in VRAM; effectively the
 *          address (which must be a multiple of 0x2000) divided by 0x400
 * PA6: Used for 128k VRAM only
 */
#define VDP_REG02 0x8200

/**
 * \def VDP_REG03
 * \brief Window Name Table VRAM Address
 * \details
 * |  7|   6|   5|   4|   3|   2|   1|  0|
 * |---+----+----+----+----+----+----+---|
 * | 0 | W6 | W5 | W4 | W3 | W2 | W1 | 0 |
 *
 * W5-W1: Bits 15-11 of window nametable address in VRAM; effectively the
 *        address (which must be a multiple of 0x800) divided by 0x400
 * W1: Ignored in 40 cell mode, limiting the address to a multiple of 0x1000
 * W6: Used for 128k VRAM only
 */
#define VDP_REG03 0x8300

/**
 * \def VDP_REG04
 * \brief Plane B Name Table VRAM Address
 * \details
 * |  7|  6|  5|  4|    3|    2|    1|    0|
 * |---+---+---+---+-----+-----+-----+-----|
 * | 0 | 0 | 0 | 0 | PB3 | PB2 | PB1 | PB0 |
 *
 * PB2-PB0: Bits 15-13 of Plane B nametable address in VRAM; effectively the
 *          address (which must be a multiple of $2000) divided by $2000
 * PB3: Used for 128k VRAM only
 */
#define VDP_REG04 0x8400

/**
 * \def VDP_REG05
 * \brief Sprite Table VRAM Address
 * \details
 * |    7|    6|    5|    4|    3|    2|    1|    0|
 * |-----+-----+-----+-----+-----+-----+-----+-----|
 * | ST7 | ST6 | ST5 | ST4 | ST3 | ST2 | ST1 | ST0 |
 *
 * ST6-ST0: Bits 15-9 of sprite table address in VRAM; effectively the address
 *          (which must be a multiple of $200) divided by $200
 * ST0: Ignored in 40 cell mode, limiting the address to a multiple of $400
 * ST7: Used for 128k VRAM only
 */
#define VDP_REG05 0x8500

/**
 * \def VDP_REG06
 * \brief Sprite Table VRAM Address (128k VRAM)
 * \details
 * |  7|  6|    5|  4|  3|  2|  1|  0|
 * |---+---+-----+---+---+---+---+---|
 * | 0 | 0 | SP5 | 0 | 0 | 0 | 0 | 0 |
 *
 * SP5: Bit 16 of sprite table address, for 128k VRAM only
 */
#define VDP_REG06 0x8600

/**
 * \def VDP_REG07
 * \brief Background Color
 * \details
 * |  7|  6|    5|    4|   3|   2|   1|   0|
 * |---+---+-----+-----+----+----+----+----|
 * | 0 | 0 | PL1 | PL0 | C3 | C2 | C1 | C0 |
 *
 * PL1-PL0: Palette line
 * C3-C0: Color
 */
#define VDP_REG07 0x8700

/**
 * \def VDP_REG08
 * \brief Unused
 * \details
 * Master System horizontal scroll register
 */
#define VDP_REG08 0x8800

/**
 * \def VDP_REG09
 * \brief Unused
 * \details
 * Master System vertical scroll register
 */
#define VDP_REG09 0x8900

/**
 * \def VDP_REG0A
 * \brief Horizontal Interrupt Counter
 * \details
 * |   7|   6|   5|   4|   3|   2|   1|   0|
 * |----+----+----+----+----+----+----+----|
 * | H7 | H6 | H5 | H4 | H3 | H2 | H1 | H0 |
 *
 * H7-H0: Number of scanlines between horizontal interrupts
 */
#define VDP_REG0A 0x8A00

/**
 * \def VDP_REG0B
 * \brief Mode Register 3
 * \details
 * |  7|  6|  5|  4|    3|   2|    1|    0|
 * |---+---+---+---+-----+----+-----+-----|
 * | 0 | 0 | 0 | 0 | IE2 | VS | HS1 | HS2 |
 *
 * IE2: 1 = enable external interrupts
 * VS: Vertical scrolling mode
 *     1 = 16 pixel columns (1 word per column in VSRAM)
 *     0 = full screen (1 longword only in VSRAM).
 * HS1-HS2: Horizontal scrolling mode
 *          00 = full screen
 *          01 = invalid
 *          10 = 8 pixel rows
 *          11 = single pixel rows.
 */
#define VDP_REG0B 0x8B00

/**
 * \def VDP_REG0C
 * \brief Mode Register 4
 * \details
 * |    7|    6|    5|   4|   3|    2|    1|    0|
 * |-----+-----+-----+----+----+-----+-----+-----|
 * | RS1 | VSY | HSY | EP | SH | LS1 | LS0 | RS0 |
 *
 * RS1/RS0: 1 = 40 cell mode (320 pixel width)
 *          0 = 32 cell mode (256 pixel width)
 *          Both bits must be the same
 * VSY: Replace vertical sync signal with pixel bus clock
 * HSY:
 * EP: 1 = enable external pixel bus
 * SH: 1 = enable shadow/highlight mode
 * LS1-LS0: Interlace mode
 *          00 = no interlace
 *          01 = interlace normal resolution
 *          10 = no interlace
 *          11 = interlace double resolution.
 */
#define VDP_REG0C 0x8C00

/**
 * \def VDP_REG0D
 * \brief Horizontal Scroll Data VRAM Address
 * \details
 * |  7|    6|    5|    4|    3|    2|    1|    0|
 * |---+-----+-----+-----+-----+-----+-----+-----|
 * | 0 | HS6 | HS5 | HS4 | HS3 | HS2 | HS1 | HS0 |
 *
 * HS5-HS0: Bits 15-10 of horizontal scroll data address in VRAM; effectively
 * the address (which must be a multiple of $400) divided by $400
 * HS6: Used for 128k VRAM only
 *
 */
#define VDP_REG0D 0x8D00

/**
 * \def VDP_REG0E
 * \brief Plane A/B Name Table VRAM Address (128k VRAM)
 * \details
 * |  7|  6|  5|    4|  3|  2|  1|    0|
 * |---+---+---+-----+---+---+---+-----|
 * | 0 | 0 | 0 | PB4 | 0 | 0 | 0 | PA0 |
 *
 * PB4: Bit 16 of Plane B nametable address in 128k VRAM
 * PA0: Bit 16 of Plane A nametable address in 128k VRAM
 */
#define VDP_REG0E 0x8E00

/**
 * \def VDP_REG0F
 * \brief Auto-Increment Value
 * \details
 * |     7|     6|     5|     4|     3|     2|     1|     0|
 * |------+------+------+------+------+------+------+------|
 * | INC7 | INC6 | INC5 | INC4 | INC3 | INC2 | INC1 | INC0 |
 *
 * INC7-INC0: Value to be added to the VDP address register after each
 * read/write to the data port; 2 is most common value
 */
#define VDP_REG0F 0x8F00

/**
 * \def VDP_REG10
 * \brief Plane Dimensions
 * \details
 * |  7|  6|   5|   4|  3|  2|   1|   0|
 * |---+---+----+----+---+---+----+----|
 * | 0 | 0 | H1 | H0 | 0 | 0 | W1 | W0 |
 *
 * H1-H0: Height setting for planes A & B
 *        00 = 32 cells (256 pixels)
 *        01 = 64 cells (512 pixels)
 *        10 = invalid
 *        11 = 128 cells (1024 pixels)
 * W1-W0: Width setting for planes A & B)
 *        (Same settings as height)
 * Height/width settings of 64x128 or 128x128 cells are invalid due to a
 * maximum plane size of $2000 bytes
 */
#define VDP_REG10 0x9000

/**
 * \def VDP_REG11
 * \brief Window Plane Horizontal Posizion
 * \details
 * |  7|  6|  5|    4|    3|    2|    1|    0|
 * |---+---+---+-----+-----+-----+-----+-----|
 * | R | 0 | 0 | HP4 | HP3 | HP2 | HP1 | HP0 |
 *
 * R: Edge selection
 *    1 = draw window from HP to right edge of screen
 *    0 = draw window from HP to left edge of screen.
 * HP4-HP0: Horizontal position on screen to start drawing the
 *          window plane (in units of 8 pixels)
 */
#define VDP_REG11 0x9100

/**
 * \def VDP_REG12
 * \brief Window Plane Verticalzion
 * \details
 * |  7|  6|  5|    4|    3|    2|    1|    0|
 * |---+---+---+-----+-----+-----+-----+-----|
 * | D | 0 | 0 | VP4 | VP3 | VP2 | VP1 | VP0 |
 *
 * D: Edge selection
 *    1 = draw window from VP to bottom edge of screen
 *    0 = draw window from VP to top edge of screen.
 * VP4-VP0: Vertical position on screen to start drawing the
 *          window plane (in units of 8 pixels)
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

#endif
