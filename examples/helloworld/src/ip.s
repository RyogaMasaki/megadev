/*
  Very simple Hello World example
  We'll load the BIOS font and display some text
*/

#include "macros.s"
#include "cd_main_def.h"
#include "cd_main_boot_def.h"
#include "vdp_def.h"
#include "io_def.h"

.section .text

// the security code for the region must *always* be at the very beginning of
// the IP code
  .incbin "sec_us.bin"

ip_entry:
  // First, disable all interrupts while we get things set up
  ori #0x700,sr

  /*
    Something we need to do very early on is start informing the Sub CPU of 
    vblank interrupts. The VINT handler built into the Boot ROM takes care of
    this, so let's go ahead and point the VINT vector (interrupt level 6) to
    the built in handler.
  */
  move.l	#_BOOT_VINT, (_mlevel6 + 2)

  move.b #0, (GA_COMFLAGS)

  // We'll also use the Boot ROM VDP defaults
  // (these defaults include disabling the display)
  jbsr _BOOT_LOAD_VDPREGS_DEFAULT
  
  // Clear all of VRAM to give a fresh start
  jbsr _BOOT_CLEAR_VRAM

  /*
    Now we'll load the internal Boot ROM font into the VDP with the default
    settings
  */
  jbsr _BOOT_LOAD_FONT_DEFAULTS
  
  // The font uses palette entry #1, so we'll manually set that to white
  move.l #0xC0020000, (VDP_CTRL)
  move.w #0x0EEE, (VDP_DATA)

  // Call our utility function to get the x/y position of a tile
  move.w #0x0205, d0
  jbsr nmtbl_xy_pos

  lea str_hello, a1
  jbsr _PRINT_TEXT

  // And finally enable the display
  jbsr _BOOT_VDP_DISP_ENABLE

  // and restore interrupts
  andi #0xF8FF,sr

loop:
  jbsr _BOOT_VINT_WAIT_DEFAULT
  // Inputs are updated as part of the default vint wait subroutine
  and.b #PAD_START_MSK, _INPUT_P1_PRESS
	beq loop
	
  jmp _BOOT_ENTRY

FUNC nmtbl_xy_pos
1:move.w (_PLANE_WIDTH), d1  // d1 - tiles per row
  move.w d0, d2  // d0 - x/y offsey (upper/lower bytes of the word)
  lsr.w #8, d2  // d2 has x pos
  and.w #0xff, d0  // filter d0 so it only has y pos
  mulu d1, d0
  # d0 is now y pos * tiles per row
  # add x pos
  add.b d2, d0
  # multiply by 2 for tilemap entry size
  lsl.l #1, d0
  # TODO: make this dynamic
  # or make sure we set the nmtbl base register
  add.w #0xc000, d0

  and.l #0xffff, d0
  lsl.l #2, d0
  lsr.w #2, d0
  or.l #0x4000, d0
  swap d0
  rts

.section .rodata
str_hello:
.ascii "Hello World!\xff"
.align 2
