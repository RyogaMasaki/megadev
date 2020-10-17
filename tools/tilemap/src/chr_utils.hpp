#include <utility>

#ifndef TILEMAP__CHR_UTILS_H
#define TILEMAP__CHR_UTILS_H

#include <chrgfx/chrgfx.hpp>

#include "md_gfx.hpp"
#include "tiletypes.hpp"

using namespace chrgfx;
bool is_blank_chr(u8* chr) {
  for (u8 pixel_iter{0}; pixel_iter < CHR_BYTESIZE; ++pixel_iter) {
    if (chr[pixel_iter] != 0) return false;
  }
  return true;
}

bool is_flat_chr(u8* chr) {
  u8 flatval = *chr;
  for (u8 pixel_iter{1}; pixel_iter < CHR_BYTESIZE; ++pixel_iter) {
    if (chr[pixel_iter] != flatval) return false;
  }
  return true;
}

bool is_identical_chr(u8* chr1, u8* chr2) {
  for (u8 pixel_iter{0}; pixel_iter < CHR_BYTESIZE; ++pixel_iter) {
    if (chr1[pixel_iter] != chr2[pixel_iter]) return false;
  }
  return true;
}

void vflip_chr(u8* chr) {
  int const swapcount{(int)CHR_HEIGHT / 2};
  u8* row1_offset{nullptr};
  u8* row2_offset{nullptr};

  for (u8 this_rowswap{0}; this_rowswap < swapcount; ++this_rowswap) {
    row1_offset = chr + (this_rowswap * CHR_WIDTH);
    row2_offset = chr + ((7 - this_rowswap) * CHR_WIDTH);
    std::swap_ranges(row1_offset, row1_offset + CHR_WIDTH, row2_offset);
  }
}

void hflip_chr(u8* chr) {
  int const swapcount{(int)CHR_WIDTH / 2};
  // u8* pxl1_offset{nullptr};
  // u8* pxl2_offset{nullptr};
  size_t pxl1_offset{0};
  size_t pxl2_offset{0};
  // two loops, one for each row
  // inner loop for each pixel swap in that row
  for (u8 this_row{0}; this_row < CHR_HEIGHT; ++this_row) {
    for (u8 this_pxlswap{0}; this_pxlswap < swapcount; ++this_pxlswap) {
      // pxl1_offset = chr + (this_row * CHR_WIDTH) + this_pxlswap;
      // pxl2_offset = chr + (this_row * CHR_WIDTH) + (7 - this_pxlswap);

      pxl1_offset = (this_row * CHR_WIDTH) + this_pxlswap;
      pxl2_offset = (this_row * CHR_WIDTH) + (7 - this_pxlswap);
      std::swap(chr[pxl1_offset], chr[pxl2_offset]);
    }
  }
}

#endif