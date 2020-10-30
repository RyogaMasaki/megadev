
.section .text



/*
IN:
a0 - ptr to tilemap
d0 - word- vram offset to place the tilemap
d1 - byte - tiles per row
d2 - long (split) - upper: base tile, lower: priority/palette settings (upper three bits of word, should be prepared!)


- get resolution of plane (vdp register 0x10)
- get width of tilemap (first)
- d6 - column counter
*/

.global load_tilemap
load_tilemap:
	PUSHM d0-d7
	
	# clear run counter
	moveq #0, d3
	# clear column counter
	moveq #0, d7

	and.l #0xffff, d0
	and.l #0xff, d1

	# d1 is tiles per row
	# number of tiles * 2 since each entry is 2 bytes
	lsl.w #1, d1

	# get tilemap size (first word)
	move.w (a0)+, d5

3:# d0 is ptr to start of row
	# copy it so we can modify it for VDP adrress format
	move.l d0, d6
	MAKE_VDP_ADDR d6
	or.l #VRAM_WRITE, d6
	move.l d6, VDP_CTRL
	
	# RESERVED:
	# d0 vram ptr for nametable writes
	# d1 num tiles per row
	# d2 tilemap settings (priority, palette, tile base)
	# d3 run counter
	# d4 tilemap entry
	# d5 tilemap width
	# d6 work
	# d7 column counter
	# which of these can be moved to RAM...?

4:# check for tile run
	cmp #0, d3
	# no run present
	beq 5f
	# run present, subtract 1 and jump down to copy
	subq #1, d3
	bra 9f

	##### get tilemap entry
5:move.w (a0)+, d4
	# ffff - end of tilemap - outta here!
	cmp.w #0xffff, d4
	beq 2f

	##### rle bit checking init
	# make a copy of tilemap entry for rle checking
	move.w d4, d6

	##### rle bit checking
	# mask off all rle bits on work entry
	and.w #0xe000, d6
	# no rle bits set?
	cmp.w #0, d6
	# no rle bits, completely normal tile, branch down and format the entry
	beq 1f
8:# check blank run bit
	cmp.w #0x2000, d6
	# no, not a blank run
	bne 7f
	# yes, get the count of blanks
	move.w d4, d3
	and.w #0x07ff, d3
	# account for our first write below
	subq #1, d3
	# set the tilemap entry to write to blank (tile 0)
	moveq #0, d4
	bra 9f

7:# tile run bits set, shift them down 
	lsr.w #8, d6
	lsr.w #5, d6
	# and copy to run counter
	move.w d6, d3
	# account for our first write below
	subq #1, d3

1:###### format tilemap entry
	# clear rle bits on original
	and.w #0x1fff, d4
	# apply palette and priority
	or.w d2, d4
	# change to base tile value in d2 upper word...
	swap d2
	# add in the base tile
	add.w d2, d4
	# reset d2
	swap d2
	# d4 is our tile to write

	###### write tilemap entry to vram
9:# set the tilemap entry in vram
	move.w d4, VDP_DATA
	# increase our column counter
	add #1, d7
	# check if we need to move to next row
	cmp.w d5, d7
	# not yet at our tilemap width
	bne 4b
	# hit tilemap width, move to next row
	moveq #0, d7
	# d1 is num tiles per row, d0 is ptr to addr in nametable
	add.l d1, d0
	bra 3b
2:POPM d0-d7
	rts







/*
IN:
a0 - ptr to tilemap
d0 - word- vram offset of the tilemap
d1 - byte - tiles per row

- get resolution of plane (vdp register 0x10)
- get width of tilemap (first)
- d6 - column counter
*/

.global clear_tilemap
clear_tilemap:
	PUSHM d0-d7
	
	# clear run counter
	moveq #0, d3
	# clear column counter
	moveq #0, d7

	and.l #0xffff, d0
	and.l #0xff, d1

	# d1 is tiles per row
	# number of tiles * 2 since each entry is 2 bytes
	lsl.w #1, d1

	# get tilemap size (first word)
	move.w (a0)+, d5

3:# d0 is ptr to start of row
	# copy it so we can modify it for VDP adrress format
	move.l d0, d6
	MAKE_VDP_ADDR d6
	or.l #VRAM_WRITE, d6
	move.l d6, VDP_CTRL
	moveq #0, d2
	
	# RESERVED:
	# d0 vram ptr for nametable writes
	# d1 num tiles per row
	# d3 run counter
	# d4 tilemap entry
	# d5 tilemap width
	# d6 work
	# d7 column counter
	# which of these can be moved to RAM...?

4:# check for tile run
	cmp #0, d3
	# no run present
	beq 5f
	# run present, subtract 1 and jump down to copy
	subq #1, d3
	bra 9f

	##### get tilemap entry
5:move.w (a0)+, d4
	# ffff - end of tilemap - outta here!
	cmp.w #0xffff, d4
	beq 2f

	##### rle bit checking init
	# make a copy of tilemap entry for rle checking
	move.w d4, d6

	##### rle bit checking
	# mask off all rle bits on work entry
	and.w #0xe000, d6
	# no rle bits set?
	cmp.w #0, d6
	# no rle bits, completely normal tile, branch down and format the entry
	beq 9f
8:# check blank run bit
	cmp.w #0x2000, d6
	# no, not a blank run
	bne 7f
	# yes, get the count of blanks
	move.w d4, d3
	and.w #0x07ff, d3
	# account for our first write below
	subq #1, d3
	bra 9f

7:# tile run bits set, shift them down 
	lsr.w #8, d6
	lsr.w #5, d6
	# and copy to run counter
	move.w d6, d3
	# account for our first write below
	subq #1, d3

	###### write tilemap entry to vram
9:# set the tilemap entry in vram
	move.w d2, VDP_DATA
	# increase our column counter
	add #1, d7
	# check if we need to move to next row
	cmp.w d5, d7
	# not yet at our tilemap width
	bne 4b
	# hit tilemap width, move to next row
	moveq #0, d7
	# d1 is num tiles per row, d0 is ptr to addr in nametable
	add.l d1, d0
	bra 3b
2:POPM d0-d7
	rts

.section .bss

tilemap_pos_x:
.word 0
tilemap_pos_y:
.word 0
tilemap_width:
.word 0
tilemap_plane_ptr:
.long 0

.align 2
