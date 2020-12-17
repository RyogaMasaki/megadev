/**
 * tilemap.c
 *
 */
#include "tilemap.h"

void load_tilemap_c(u8 const* tilemap, u16 nametable_offset, u8 tiles_per_row,
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

void clear_tilemap_c(u8 const* tilemap, u16 nametable_offset,
                     u8 tiles_per_row) {
  register u8 const* tilemap_a0 asm("a0") = tilemap;
  register u16 nametable_offset_d0 asm("d0") = nametable_offset;
  register u8 tiles_per_row_d1 asm("d1") = tiles_per_row;

  asm("jsr clear_tilemap"
      :
      : "a"(tilemap_a0), "d"(nametable_offset_d0), "d"(tiles_per_row_d1));
  return;
};