
#include "types.h"
#include "cd_main_boot.h"
#include "vdp.h"
#include "cd_main_boot_def.h"
#include "io_def.h"
#include "cd_main.h"

extern u16 global_mode;

void main() {
	boot_print_string("Example file Number Two!\xff", 
		(to_vdpaddr(
			NMT_POS_PLANE(9,6,BOOT_PLANE_WIDTH,BOOT_PLANEA_ADDR))
			 | VDP_VRAM_W));

	do {
		vint_wait();
	} while(!(PAD_P1_PRESS & PAD_START_MSK));

	global_mode = 2;
	return;
}

