
.section .text

/*
IN:
a0 - ptr to tilemap
d0 - word - x/y pos (x upper byte, y lower byte)
d1 - priority/palette line (pri upper work, pal lower)

two function "intros": one for plane a, another for plane b
- a1 - ptr to nametable entry
- initial a1 = nametable base (read from vdp register, shift as necessary)

- get resolution of plane (vdp register 0x10)
- get width of tilemap (first)
- d6 - column counter
*/

.global load_tilemap_plane_b_c
load_tilemap_plane_b_c:
	movea.l	4(sp), a0
	move.l	8(sp), d0
	move.l	0xc(sp), d1

# set vdp auto increment to 2
load_tilemap_plane_b:
	PUSHM d0-d7
	moveq #0, d6
	CALC_NMTBL_ADDR_PLANE_B d6
	bra load_tilemap

.global load_tilemap_plane_a_c
load_tilemap_plane_a_c:
	movea.l	4(sp), a0
	move.l	8(sp), d0
	move.l	0xc(sp), d1

# set vdp auto increment to 2
load_tilemap_plane_a:
	PUSHM d0-d7
	moveq #0, d6
	CALC_NMTBL_ADDR_PLANE_A d6

load_tilemap:
	######### get tilemap pos
	#copy our original extra info (palette line) to d5
	move.w d1, d5
	jsr vdp_xy_pos
	# number of tiles * 2 since each entry is 2 bytes
	lsl.l #1, d1
	# d0 now has offset for x/y, d1 has datasize of row
	# d6 should have ptr to plane nametable
	# d0 will track the offset of row starts
	add.l d6, d0

	# get tilemap size (first word)
	move.w (a0)+, tilemap_width
	moveq #0, d7

	# TODO - get tile priority!
	# get palette line
	and.l #0xffff, d5
	lsl.w #8, d5
	lsl.w #5, d5
	# d5 has palette line
	
	# clear run counter
	moveq #0, d2

3:# d0 is ptr to start of row
	# copy it so we can modify it for VDP adrress format
	move.l d0, d6
	CALC_VDP_CTRL_ADDR d6 d4
	or.l #VRAM_WRITE, d6
	move.l d6, VDP_CTRL
	
	# RESERVED:
	# d0 ptr to row start
	# d1 num tiles per row
	# d2 run counter
	# d3 tilemap entry
	# d4 
	# d5 copy of d0 from start (xy pos)
	# d6 work
	# d7 column counter
	# which of these can be moved to RAM...?

4:# check for tile run
	cmp #0, d2
	# no run present
	beq 5f
	# run present, subtract 1 and jump down to copy
	subq #1, d2
	bra 9f

5:move.w (a0)+, d3
	# ffff - end of tilemap
	cmp.w #0xffff, d3
	beq 2f

	##### rle bit checking init
	# make a copy of tilemap entry for rle checking
	move.w d3, d6
	# clear rle bits on original
	and.w #0x1fff, d3
	# apply palette, d3 is now the tilemap entry to write
	or.w d5, d3
	##### rle bit checking
	# mask off all rle bits on work entry
	and.w #0xe000, d6
	# no rle bits set?
	cmp.w #0, d6
	# no rle bits, completely normal tile, branch down and copy it to vram
	beq 9f
8:# check blank run bit
	cmp.w #0x2000, d6
	# no, not a blank run
	bne 7f
	# yes, get the count of blanks
	move.w d3, d2
	and.w #0x07ff, d2
	# account for our first write below
	subq #1, d2
	# set the tilemap entry to write to blank (tile 0)
	moveq #0, d3
	bra 9f

7:# tile run bits set, shift them down 
	lsr.w #8, d6
	lsr.w #5, d6
	# and copy to run counter
	move.w d6, d2
	# account for our first write below
	subq #1, d2

9:# set the tilemap entry in vram
	move.w d3, VDP_DATA
	# increase our column counter
	add #1, d7
	# check if we need to move to next row
	# TODO store width in a register
	cmp.w tilemap_width, d7
	# not yet at our tilemap width
	bne 4b
	# hit tilemap width, move to next row
	moveq #0, d7
	# d1 is num tiles per row, d0 is ptr to normalized start of tile row in vram
	add.l d1, d0
	bra 3b
2:POPM d0-d7
	rts

.section .data

tilemap_pos_x: .word 1
tilemap_pos_y: .word 1
tilemap_width: .word 1
tilemap_plane_ptr: .long 1
.align 2
