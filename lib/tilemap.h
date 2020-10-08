#ifndef MEGADEV__TILEMAP_H
#define MEGADEV__TILEMAP_H

#include "types.h"

extern void load_tilemap_plane_a_c(void *tilemap, u16 xy_pos, unsigned int other);

extern void load_tilemap_plane_b_c(void *tilemap, u16 xy_pos, unsigned int other);

#endif