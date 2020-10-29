#include <utility>

#ifndef TILEMAP__TILEOPT_H
#define TILEMAP__TILEOPT_H

#include <chrgfx/chrgfx.hpp>

#include "chr_utils.hpp"
#include "md_gfx.hpp"
#include "tiletypes.hpp"

std::vector<TileOptMeta> optimize_tiles(chrbank const& src_tiles) {
  // allocate some space for flipping a test tile around
  u8 temp_flip_work[CHR_BYTESIZE];

  std::vector<TileOptMeta> out_optmeta;
  out_optmeta.reserve(src_tiles.size());

  size_t this_orig_idx{0};

  // pass 1 - identify flat & blank tiles and generate CRCs for normal tiles
  for (auto const& this_tile : src_tiles) {
    TileOptMeta this_tile_meta;

    this_tile_meta.DataPtr = this_tile.get();
    this_tile_meta.OrigIdx = this_orig_idx++;

    // check if tile is blank (all color 0, i.e. invisible)
    if (is_blank_chr(this_tile.get())) {
      this_tile_meta.IsNull = true;
      this_tile_meta.Type = TileType::BLANK;
      goto end_checks;
    }

    // check if tile is flat (all one color)
    if (is_flat_chr(this_tile.get())) {
      // if the tile is flat, set its color and move on
      this_tile_meta.IsFlat = true;
      this_tile_meta.Type = TileType::FLAT;
      this_tile_meta.FlatPalEntry = this_tile[0];
      goto end_checks;
    }

    // neither blank nor flat, must be normal
    this_tile_meta.Type = TileType::NORMAL;

    // get CRC for tile in all positions
    // crc for natural
    this_tile_meta.tile_crc = crc32(0, this_tile.get(), CHR_BYTESIZE);

    // crc for hflip
    std::copy(this_tile.get(), this_tile.get() + CHR_BYTESIZE, temp_flip_work);
    hflip_chr(temp_flip_work);
    this_tile_meta.tile_hflip_crc = crc32(0, temp_flip_work, CHR_BYTESIZE);

    // crc for vflip
    std::copy(this_tile.get(), this_tile.get() + CHR_BYTESIZE, temp_flip_work);
    vflip_chr(temp_flip_work);
    this_tile_meta.tile_vflip_crc = crc32(0, temp_flip_work, CHR_BYTESIZE);

    // crc for hvflip
    std::copy(this_tile.get(), this_tile.get() + CHR_BYTESIZE, temp_flip_work);
    hflip_chr(temp_flip_work);
    vflip_chr(temp_flip_work);
    this_tile_meta.tile_hvflip_crc = crc32(0, temp_flip_work, CHR_BYTESIZE);

  end_checks:
    out_optmeta.push_back(this_tile_meta);
  }

  // pass 2 - identify duplicates
  // loop through each tile backwards (the work tile)
  // compare each CRC of the work tile to the NORMAL CRC of each tile going
  // forward (compare tile)
  // if there is a match, do a deep compare to ensure the match is valid
  // if a true match, set the work tile as dupe, point the dupe index
  // to the compare tile and set flip flags if necessary so it matches

  // loop backwards (work tiles)
  for (auto work_tile{out_optmeta.rbegin()}; work_tile != out_optmeta.rend();
       ++work_tile) {
    // always ignore blank tiles
    if (work_tile->Type == TileType::BLANK) {
      continue;
    }

    // loop forwards (compare tiles)
    size_t compare_tile_idx{0};
    for (auto compare_tile{out_optmeta.begin()};
         compare_tile != out_optmeta.end();
         ++compare_tile, ++compare_tile_idx) {
      // tile to compare against is empty? move along
      if (compare_tile->Type == TileType::BLANK) {
        continue;
      }

      // working on the same tile? move along
      if (&(*work_tile) == &(*compare_tile)) {
        continue;
      }

      // if the tile already has a dupe elsewhere, move along
      // (we'll find the one it refers to later)
      if (compare_tile->DupeIdx.has_value()) {
        continue;
      }

      // if our current tile is flat, check only against other flats
      if (work_tile->Type == TileType::FLAT) {
        // if both tiles are flat, see if they share the same color
        if (compare_tile->Type == TileType::FLAT &&
            work_tile->FlatPalEntry == compare_tile->FlatPalEntry) {
          // we have a dupe!
          work_tile->HasDupe = true;
          work_tile->DupeIdx = compare_tile_idx;
          // exit our dupe check loop
          break;
        }
        // ignore flat tiles if our test tile is not also flat
        continue;
      }

      // compare normal tile
      if (work_tile->tile_crc == compare_tile->tile_crc) {
        // we (might) have a dupe!
        // do deep compare to be sure there wasn't a CRC collision
        if (is_identical_chr(work_tile->DataPtr, compare_tile->DataPtr)) {
          // we have a dupe!
          work_tile->HasDupe = true;
          work_tile->DupeIdx = compare_tile_idx;
          // break out of the loop, since we've found a dupe
          // (presumably, the first one since our compare loop moves forward)
          break;
        }
      }

      // compare against hflip tile
      if (work_tile->tile_hflip_crc == compare_tile->tile_crc) {
        // we (might) have a dupe!
        std::copy(work_tile->DataPtr, work_tile->DataPtr + CHR_BYTESIZE,
                  temp_flip_work);
        hflip_chr(temp_flip_work);
        if (is_identical_chr(temp_flip_work, compare_tile->DataPtr)) {
          // we have a dupe!
          work_tile->HasDupe = true;
          work_tile->DupeIdx = compare_tile_idx;
          work_tile->DupeHFlip = true;
          break;
        }
      }

      // compare against vflip tile
      if (work_tile->tile_vflip_crc == compare_tile->tile_crc) {
        // we (might) have a dupe!
        std::copy(work_tile->DataPtr, work_tile->DataPtr + CHR_BYTESIZE,
                  temp_flip_work);
        vflip_chr(temp_flip_work);
        if (is_identical_chr(temp_flip_work, compare_tile->DataPtr)) {
          // we have a dupe!
          work_tile->HasDupe = true;
          work_tile->DupeIdx = compare_tile_idx;
          work_tile->DupeVFlip = true;
          break;
        }
      }

      // compare against hvflip tile
      if (work_tile->tile_hvflip_crc == compare_tile->tile_crc) {
        // we (might) have a dupe!
        std::copy(work_tile->DataPtr, work_tile->DataPtr + CHR_BYTESIZE,
                  temp_flip_work);
        hflip_chr(temp_flip_work);
        vflip_chr(temp_flip_work);
        if (is_identical_chr(temp_flip_work, compare_tile->DataPtr)) {
          // we have a dupe!
          work_tile->HasDupe = true;
          work_tile->DupeIdx = compare_tile_idx;
          work_tile->DupeHFlip = true;
          work_tile->DupeVFlip = true;
          break;
        }
      }
    }
    // if we reached this part of the loop, there have been no dupes
    // keep on movin'
  }

  // at this point, tiles should be marked as duplicates

  // pass 3 - re-order unique (non-dupe) tiles
  size_t final_tile_idx{0};

  // put flats at the front
  // no particular reason for this, just makes things "cleaner", imo
  for (auto& this_tile : out_optmeta) {
    if ((this_tile.Type == TileType::FLAT) & !this_tile.DupeIdx) {
      this_tile.OptIdx = final_tile_idx++;
    }
  }

  // put the rest of the non-dupe tiles
  for (auto& this_tile : out_optmeta) {
    if ((this_tile.Type == TileType::NORMAL) & !this_tile.DupeIdx) {
      this_tile.OptIdx = final_tile_idx++;
    }
  }

  // all non-dupe tiles should have a final index now
  // for each duped tile, set the final index
  for (auto& this_tile : out_optmeta) {
    if (this_tile.DupeIdx) {
      this_tile.OptIdx = out_optmeta[this_tile.DupeIdx.value()].OptIdx;
    }
  }

  return out_optmeta;
}

// create final list of tiles to be exported
std::vector<u8*> make_tile_list(std::vector<TileOptMeta> const& optmeta) {
  size_t final_tile_count{0};

  // not the most efficient way to do things but eh...
  for (auto const& this_tile : optmeta) {
    if (this_tile.OptIdx && this_tile.OptIdx.value() > final_tile_count) {
      final_tile_count = this_tile.OptIdx.value();
    }
  }
  ++final_tile_count;

  std::vector<u8*> final_tiles(final_tile_count, nullptr);

  for (auto const& this_tile : optmeta) {
    if (this_tile.OptIdx && final_tiles[this_tile.OptIdx.value()] == nullptr) {
      final_tiles[this_tile.OptIdx.value()] = this_tile.DataPtr;
    }
  }

  return final_tiles;
}

std::vector<TilemapEntry> optimize_tilemap(
    std::vector<TileOptMeta> const& optmeta, bool no_optimize = false) {
  std::vector<TilemapEntry> out_tilemap;

  if (no_optimize) {
    TilemapEntry this_tilemap_entry;
    for (auto const& this_tile : optmeta) {
      this_tilemap_entry.TileID = this_tile.OptIdx;
      out_tilemap.push_back(this_tilemap_entry);
    }
    return out_tilemap;
  }

  size_t runlength{1};

  auto this_tile{optmeta.begin()};

  TilemapEntry prev_tile;

  // pull in data from the first tile
  prev_tile.TileID = this_tile->OptIdx;
  prev_tile.HFlip = this_tile->DupeHFlip;
  prev_tile.VFlip = this_tile->DupeVFlip;

  // move to the next tile to begin comparison
  ++this_tile;

  for (; this_tile != optmeta.end(); ++this_tile) {
    // if this tile and the previous were empty, add to run
    if ((this_tile->Type == TileType::BLANK) && !prev_tile.TileID) {
      ++runlength;
      continue;
    }

    // if we're here, we're dealing with a flat or normal tile
    // check if the tile ID, hflip and vflip are all identical
    if ((this_tile->OptIdx == prev_tile.TileID) &&
        (this_tile->DupeHFlip == prev_tile.HFlip) &&
        (this_tile->DupeVFlip == prev_tile.VFlip)) {
      ++runlength;
      // max run of 7 due to only have 3 bits to work with
      if (runlength < 7) {
        // our run is not yet up to max, check the next tile
        continue;
      }
      // we've hit a full run, stop and process it

      // (it's important to skip over the current tile for the next check
      // otherwise it will cause issues for long runs (runs over 7)
      // this is because this_tile is being included as the end of a run now
      // and if we do not skip over it, it will be marked as prev_tile in the
      // next iteration, recognized as part of a run, and included as part
      // of the next run as well, throwing things further and further off
      // with the length of the run)
      // (this was a bug that gave me quite a headache)
      ++this_tile;
    }

    // at this point, we should have accounted for a tile run
    if (runlength > 1) {
      prev_tile.RunLength = runlength;
      runlength = 1;
    }
    // add it
    out_tilemap.push_back(prev_tile);

    // prepare for next check
    // load current tile into prev tile data
    prev_tile.RunLength = 0;
    prev_tile.TileID = this_tile->OptIdx;
    prev_tile.HFlip = this_tile->DupeHFlip;
    prev_tile.VFlip = this_tile->DupeVFlip;
  }
  // need to take care of any tiles that may have been in a run
  if (runlength > 1) {
    prev_tile.RunLength = runlength;
  }
  // and account for the very last tile
  out_tilemap.push_back(prev_tile);

  return out_tilemap;
}

std::vector<u16> make_tilemap_list(
    std::vector<TilemapEntry> const& tilemap_list, u16 tile_base, u16 width) {
  // tilemap format:
  // |   | | |           |
  //  xxx v h ttttttttttt
  // t - tile id
  // v, h - flip bits
  // xxx - empty/run length

  // for xxx, if only low bit is set, indicates this is a run of blank tiles
  // all lower bits (0 to 12) will be used for the run length of blank tiles
  // if any other xxx bits are set, all lower bits are as normal, and the xxx
  // bits count as the run length

  // each tilemap entry is 16 bits
  std::vector<u16> out;
  // the +2 account for width specifier and list terminator
  out.reserve(tilemap_list.size() + 2);
  out.push_back(width);

  u16 this_raw_entry{0};
  for (auto const& this_list_entry : tilemap_list) {
    this_raw_entry = 0;
    if (!this_list_entry.TileID) {
      // no tile id = empty tile
      // quick bug fix - check that run length is greater than 0 before setting
      // the empty tile run flag
      this_raw_entry = 0x2000;
      this_raw_entry |=
          (this_list_entry.RunLength && this_list_entry.RunLength.value() > 0)
              ? (this_list_entry.RunLength.value() & 0x1fff)
              : 1;
      out.push_back(this_raw_entry);
    } else {
      if (this_list_entry.RunLength) {
        u8 temp{(u8)this_list_entry.RunLength.value()};
        this_raw_entry = (temp &= 0x7);
        this_raw_entry <<= 13;
      }
      this_raw_entry |= (this_list_entry.TileID.value() & 0x7ff);
      if (this_list_entry.HFlip) {
        this_raw_entry |= 0x800;
      }
      if (this_list_entry.VFlip) {
        this_raw_entry |= 0x1000;
      }
      out.push_back(this_raw_entry + tile_base);
    }
  }

  // list terminator
  out.push_back((u16)0xffff);
  return out;
}
#endif
