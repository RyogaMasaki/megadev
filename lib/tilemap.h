/**
 * \file tilemap.h
 * Tilemap system
 */

#ifndef MEGADEV__TILEMAP_H
#define MEGADEV__TILEMAP_H

#include "types.h"

#define TILEMAP_SETTINGS(palette_line, priority, base_tile)     \
  ((base_tile & 0x07FF) << 16) | ((palette_line & 0x3) << 13) | \
      ((priority & 0x1) << 15)

/**
 * Load a tilemap to a nametable
 */
inline void load_tilemap_c(u8 const* tilemap, u16 nametable_offset, u8 tiles_per_row,
                    u32 settings) {
  register u8 const* tilemap_a0 asm("a0") = tilemap;
  register u16 nametable_offset_d0 asm("d0") = nametable_offset;
  register u8 tiles_per_row_d1 asm("d1") = tiles_per_row;
  register u32 settings_d2 asm("d2") = settings;

  asm("jsr load_tilemap"
      :
      : "a"(tilemap_a0), "d"(nametable_offset_d0), "d"(tiles_per_row_d1),
        "d"(settings_d2));
  return;
};

/**
 * Clears a tilemap that was loaded to a nametable
 */
inline void clear_tilemap_c(u8 const* tilemap, u16 nametable_offset,
                     u8 tiles_per_row) {
  register u8 const* tilemap_a0 asm("a0") = tilemap;
  register u16 nametable_offset_d0 asm("d0") = nametable_offset;
  register u8 tiles_per_row_d1 asm("d1") = tiles_per_row;

  asm("jsr clear_tilemap"
      :
      : "a"(tilemap_a0), "d"(nametable_offset_d0), "d"(tiles_per_row_d1));
  return;
};

#endif