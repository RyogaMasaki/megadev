#ifndef SPRITER__SPRITE_MAKETBL_HPP
#define SPRITER__SPRITE_MAKETBL_HPP

#include "spritedef.hpp"
#include <array>
#include <chrgfx/chrgfx.hpp>
#include <vector>

using namespace chrgfx;

std::vector<std::array<u16, 4>> make_tbl(std::vector<SpriteDef> const &defs,
																				 u16 base_tile = 0)
{
	std::vector<std::array<u16, 4>> out;
	u16 tile_offset{base_tile};
	for(auto const &this_def : defs) {
		if(!this_def.IsValid) {
			continue;
		}

		std::array<u16, 4> def{0, 0, 0, 0};
		// next & hs/vs in idx 1
		// gfx in idx 2
		// others are 0
		def[1] = this_def.Next;
		u8 test1 = def[1] |=
				((((this_def.SpriteWidth - 1) << 2) | (this_def.SpriteHeight - 1))
				 << 8);
		def[2] = tile_offset;
		tile_offset += (this_def.SpriteHeight * this_def.SpriteWidth) + base_tile;
		out.push_back(def);
	}

	return out;
}
#endif
