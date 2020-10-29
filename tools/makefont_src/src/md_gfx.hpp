#ifndef TILEMAP__MD_GFX_H
#define TILEMAP__MD_GFX_H

#include <chrgfx/chrgfx.hpp>

using namespace chrgfx;

chrdef const MD_CHR{"Megadrive",
                    8,
                    8,
                    4,
                    vector<u32>{3, 2, 1, 0},
                    vector<u32>{0, 4, 8, 12, 16, 20, 24, 28},
                    vector<u32>{0, 32, 64, 96, 128, 160, 192, 224}};

paldef const MD_PAL{"Megadrive", 16, 16, 4};
coldef const MD_COL{"Megadrive", 3,
                    vector<rgb_layout>{rgb_layout{
                        std::pair{1, 3}, std::pair{5, 3}, std::pair{9, 3}}},
                    true};

uint const CHR_WIDTH{MD_CHR.get_width()};
uint const CHR_HEIGHT{MD_CHR.get_height()};

// uint const CHR_BYTESIZE{MD_CHR.get_datasize() / 8};
// we do all the work with the tiles in "standard" (8bit) format
// so a tile data size 1 byte each
uint const CHR_BYTESIZE{CHR_WIDTH * CHR_HEIGHT};

#endif