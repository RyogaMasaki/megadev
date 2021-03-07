#include "cd_main_def.h"
#include "cd_main_boot_def.h"
#include "cd_main.s"
#include "vdp_def.h"

.section .text

// the security code for the region must *always* be at the very beginning of
// the IP code
  .incbin "sec_us.bin"

ip_entry:
  // First, disable all interrupts while we get things set up
  ori #0x700,sr

  move.l	#_BOOT_VINT, (_mlevel6 + 2)

	jsr _BOOT_CLEAR_COMM

  jbsr _BOOT_LOAD_FONT_DEFAULTS
  
  // The font uses palette entry #1, so we'll manually set that to white
  move.l #0xC0020000, (VDP_CTRL)
  move.w #0x0EEE, (VDP_DATA)

  // And finally enable the display
  jbsr _BOOT_VDP_DISP_ENABLE

  // and restore interrupts
  andi #0xF8FF,sr

	GRANT_2M

  move.w	#1, GA_COMCMD0	//send the command to command register #0
	move.w  #0, GA_COMCMD1  // send sub command to reg #1 
0:tst.w		GA_COMSTAT0			//wait for response on status register #0
	beq			0b
	move.w	#0, GA_COMCMD0	//send idle command
1:tst.w		GA_COMSTAT0			//wait for response
	bne			1b

  // The file should now be present in Word RAM. We'll jump its main routine
  // pointer

	// Reset the stack
	movea.l (0), sp
	
  jmp (MAIN_2M_BASE+8)
