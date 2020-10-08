#ifndef MEGADEV__VDP_PAL_H
#define MEGADEV__VDP_PAL_H

#include "types.h"

enum Subpal{
	PAL0=0,PAL1=1,PAL2=2,PAL3=3
};

extern void vdp_load_pal_c(u8* palette);

extern void vdp_load_subpal_c(enum Subpal subpal, u8* palette);

#endif
