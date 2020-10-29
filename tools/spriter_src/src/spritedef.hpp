#ifndef SPRITER__SPRITEDEF_HPP
#define SPRITER__SPRITEDEF_HPP

#include "chrgfx/types.hpp"

struct SpriteDef {
	size_t SourceTileX{0};
	size_t SourceTileY{0};
	u8 SpriteWidth{0};
	u8 SpriteHeight{0};
	u8 Next{0};
	bool IsValid{true};
};

#endif