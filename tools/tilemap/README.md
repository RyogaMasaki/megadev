tileopt
-------

A tool for generating an optimized tilemap from an input PNG for use in Sega Mega Drive development. It is primarily meant for use with MEGADEV.

# Requirements
Requires: `libpng++`, `zlib`, and `libchrgfx`.

# Usage
`--image`,`-i`

Path to the input PNG image. If not specified, stdin will be used.

`--output`,`-o`

Specifies the base filename for output files. If not specified, it will use the filename of the input file as a basis. Required if stdin is used for input.

`--base`,`-b`

The tile offset within VRAM at which the tiles will be stored.

`--make-palette`,`p`

Creates a Mega Drive format palette from the input image

`--no-map-optimize`,`-M`

Do not optimize the tilemap. This will make the tilemap data more compatible for development outside of MEGADEV.
