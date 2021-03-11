#include "cd_main_def.h"
#include "cd_main_boot_def.h"
#include "cd_main.s"
#include "vdp_def.h"
#include "macros.s"

.section .text

// the security code for the region must *always* be at the very beginning of
// the IP code
  .incbin "sec_us.bin"

ip_entry:
  // First, disable all interrupts while we get things set up
  ori #0x700,sr

  move.l	#_BOOT_VINT, (_mlevel6 + 2)

  jbsr _BOOT_LOAD_VDPREGS_DEFAULT

  jbsr _BOOT_CLEAR_VRAM

  jbsr _BOOT_LOAD_FONT_DEFAULTS
  
  // The font uses palette entry #1, so we'll manually set that to white
  move.l #0xC0020000, (VDP_CTRL)
  move.w #0x0EEE, (VDP_DATA)

  // And finally enable the display
  jbsr _BOOT_VDP_DISP_ENABLE

  jbsr _BOOT_CLEAR_COMM

  // and restore interrupts
  andi #0xF8FF,sr

  move.w #0, (global_mode)

prep_load:
  movea.l (0), sp  // Reset the stack since we're "starting fresh"

  jbsr _BOOT_CLEAR_NMTBL // clear the screen

  GRANT_2M  // give Word RAM to Sub

  move.w	#1, GA_COMCMD0	//send the command to sub
	move.w  (global_mode), GA_COMCMD1  // send the param to sub
0:tst.w		GA_COMSTAT0			//wait for response on status reg #0
	beq			0b
	move.w	#0, GA_COMCMD0	//send idle command
1:tst.w		GA_COMSTAT0			//wait for response (wait for 0 from Sub)
	bne			1b

  jbsr mmd_exec  // launch the loaded module
  bra prep_load

// Include the code for the MMD loader here
#include "mmd_exec_main.s"

.section .bss
.global global_mode
global_mode: .word 0

