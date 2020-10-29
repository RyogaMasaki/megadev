#ifndef MEGADEV__TILEMAP_H
#define MEGADEV__TILEMAP_H

#include "types.h"

#define TILEMAP_SETTINGS(palette_line, priority, base_tile)     \
  ((base_tile & 0x07FF) << 16) | ((palette_line & 0x3) << 13) | \
      ((priority & 0x1) << 15)

/**
 * Load a tilemap to a nametable
 */
void load_tilemap_c(u8 const* tilemap, u16 nametable_offset, u8 tiles_per_row,
                    u32 settings);

/**
 * Clears a tilemap that was loaded to a nametable
 */
void clear_tilemap_c(u8 const* tilemap, u16 nametable_offset, u8 tiles_per_row);
#endif