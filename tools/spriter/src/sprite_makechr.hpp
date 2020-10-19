#ifndef SPRITER__SPRITE_MAKECHR_HPP
#define SPRITER__SPRITE_MAKECHR_HPP

#include "spritedef.hpp"
#include <chrgfx/chrgfx.hpp>
#include <vector>

using namespace chrgfx;
// when grabbing chrs, need to move vertically then horizontally

std::vector<u8 *> make_chr(chrbank const &src_tiles,
													 std::vector<SpriteDef> &defs,
													 unsigned int img_chr_width)
{
	// the pointers are managed in the original chrbank, so no worries about leaks
	// with avector full of pointers
	std::vector<u8 *> out;
	for(auto &this_def : defs) {
		if(this_def.SpriteWidth > 4 || this_def.SpriteHeight > 4) {
			std::cerr << "Invalid size for def at tile " << this_def.SourceTileX
								<< "/" << this_def.SourceTileY
								<< " - Sprite width/height may only be 4 tiles max";
			this_def.IsValid = false;
			continue;
		}

		size_t chr_offset{(this_def.SourceTileY * img_chr_width) +
											this_def.SourceTileX};
		for(int h_iter{0}; h_iter < this_def.SpriteWidth; ++h_iter) {
			for(int v_iter{0}; v_iter < this_def.SpriteHeight; ++v_iter) {
				out.push_back(
						src_tiles[chr_offset + (img_chr_width * v_iter) + h_iter].get());
			}
		}
	}

	return out;
}

#endif
