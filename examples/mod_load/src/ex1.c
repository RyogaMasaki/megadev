
#include "types.h"
#include "cd_main_boot.h"
#include "vdp.h"
#include "cd_main_boot_def.h"
#include "io_def.h"
#include "cd_main.h"

extern u16 global_mode;

void main() {
	boot_print_string("Example file Number One!\xff", 
		(to_vdpaddr(
			NMT_POS_PLANE(4,3,BOOT_PLANE_WIDTH,BOOT_PLANEA_ADDR))
			 | VDP_VRAM_W));

	do {
		vint_wait();
	} while(!(PAD_P1_PRESS & PAD_START_MSK));

	global_mode = 1;
	return;
	/*
	// load next file
	GA_COMCMD0_C = 1;
	GA_COMCMD1_C = 1;

	while(GA_COMSTAT0_C == 0) {
		asm("nop");
	}

	GA_COMCMD0_C = 0;
	GA_COMCMD1_C = 0;

	while(GA_COMSTAT0_C != 0) {
		asm("nop");
	}

	// we can just call the function (jsr) since mmd_loader clears the
	// stack anyway
  mmd_loader();
	*/
}

/*
__attribute__((interrupt)) void hint()  {
	return;
}

 
void vint() {
	goto *_BOOT_VINT;
}
*/
