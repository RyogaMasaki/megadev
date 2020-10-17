#ifndef TILEMAP__TILETYPES_H
#define TILEMAP__TILETYPES_H

#include <chrgfx/chrgfx.hpp>

using namespace chrgfx;

enum TileType { UNDEFINED, BLANK, FLAT, NORMAL };

// describes a tilemap entry
struct TilemapEntry {
  // if not set, blank (null) tile
  std::optional<size_t> TileID{std::nullopt};
  // number of entries; if not set, single tile
  std::optional<size_t> RunLength{std::nullopt};

  bool HFlip{false};
  bool VFlip{false};
};

// tile optimization meta data
struct TileOptMeta {
  // index of this tile in the original image
  size_t OrigIdx{0};

  // index of this tile in the final, optimized tile block
  std::optional<size_t> OptIdx{std::nullopt};

  TileType Type{TileType::UNDEFINED};

  // if this tile is duplicated elsewhere, this is the OrigIdx of that tile
  // (should use the DupeIdx if available)
  std::optional<size_t> DupeIdx{std::nullopt};

  bool HasDupe{false};

  // tile is blank (all palette entry 0, invisible)
  bool IsNull{false};

  // tile is all one color, with no variation
  bool IsFlat{false};
  // if the tile is flat, use this pal entry (offset of palette line)
  u8 FlatPalEntry{0};
  // indicates this tile data needs to be v/h flipped in order to match the
  // dupe
  bool DupeVFlip{false};
  bool DupeHFlip{false};

  ulong tile_crc{0};
  ulong tile_vflip_crc{0};
  ulong tile_hflip_crc{0};
  ulong tile_hvflip_crc{0};

  u8* DataPtr;
};

#endif