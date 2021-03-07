
#include "types.h"
#include "cd_main_boot.h"
#include "vdp.h"
#include "cd_main_boot_def.h"


void main() {
	boot_print_string("Example file Number Two!", to_vdpaddr(NMT_POS_PLANE(10,10,BOOT_PLANE_WIDTH,BOOT_PLANEA_ADDR)));

	do {
		vint_wait();
	} while(1);

}

__attribute__((interrupt)) void hint()  {
	return;
}

 
void vint() {
	goto *_BOOT_VINT;
}
