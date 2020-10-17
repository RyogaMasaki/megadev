/*
	This is a very simple print routine for system/debugging text
	It will always display on plane A and use palette line 0
	It assumes there is an ASCII font occupying the beginning of VRAM

	REQUIRES: vdp
*/

.section .text

/*
.macro PRINT stringptr xpos ypos
	move.w ( \xpos << 8 ) | (\ypos), d0
	lea \stringptr, a0
	jsr print
.endm
*/

/*print_c:
	movea.l	4(sp), a0
  move.l	8(sp), d0
	*/
/*
 * print
 * Prints ASCII text to scroll plane A at x/y coordinates
 * String must be \0 terminated
 * 
 * INPUT:
 * 	d0 - VRAM offset to begin printing
 * 	a0 - ptr to string
 * OUTPUT:
 * 	None
 * BREAK:
 * 	d1, d2, a5
 */

.global print
print:
/*
	# copy d1 cause it's about to get mangled
	move.l d1,d2
	jsr vdp_xy_pos
	# d0 ptr to vram for tiles
	# d1 num tiles in row (don't need)
	add.w d2, d0
	*/
	MAKE_VDP_ADDR d0
	or.l #VRAM_WRITE, d0
	move.l d0, VDP_CTRL
	lea VDP_DATA, a5
	
	/* read/send ascii data */
	moveq #0, d0
1:move.b (a0)+, d0
	beq 2f
	sub #0x20, d0
	move.w d0, (a5)
	bra 1b
2:rts

/*
	printval functions
	Prints ASCII text to scroll plane A at x/y coordinates based
	on a value from a given address
	
	IN:
		d0 - x/y pos (upper byte x, lower byte y)
		d1 - nametable offset in vram
		d2 - value
	OUT:
		None
	BREAK:
		d1, d3
*/
.global printval_u8_c
printval_u8_c:
	movea.l	4(sp), a0
	move.l	8(sp), d0

printval_u8:
	move.l d1,d3
	# d7 - counter for each 4 bits of the value
	jsr vdp_xy_pos
	# d0 ptr to vram for tiles
	# d1 num tiles in row (don't need)
	add.w d3, d0
	MAKE_VDP_ADDR d0
	or.l #VRAM_WRITE, d0
	move.l d0, VDP_CTRL

	#moveq #0, d1
	#move.b (a0), d1
  moveq #1, d7

1:rol.b #4, d2
	move.b d2, d0
	and.w #0x0f, d0
	cmp.b #0x09, d0
	bgt 2f
	add.b #0x10, d0
	bra 3f
2:add.b #0x17, d0
3:move.w d0, VDP_DATA
	dbf d7, 1b
	rts

.global printval_u16_c
printval_u16_c:
	movea.l	4(sp), a0
	move.l	8(sp), d0

printval_u16:
	move.l d1,d3
	# d7 - counter for each 4 bits of the value
	jsr vdp_xy_pos
	# d0 ptr to vram for tiles
	# d1 num tiles in row (don't need)
	add.w d3, d0
	MAKE_VDP_ADDR d0
	or.l #VRAM_WRITE, d0
	move.l d0, VDP_CTRL

	#moveq #0, d1
	#move.w (a0), d1
  moveq #3, d7

1:rol.w #4, d2
	move.w d2, d0
	and.w #0x0f, d0
	cmp.b #0x09, d0
	bgt 2f
	add.b #0x10, d0
	bra 3f
2:add.b #0x17, d0
3:move.w d0, VDP_DATA
	dbf d7, 1b
	rts

.global printval_u32_c
printval_u32_c:
	movea.l	4(sp), a0
	move.l	8(sp), d0

printval_u32:
	move.l d1,d3
	# d7 - counter for each 4 bits of the value
	jsr vdp_xy_pos
	# d0 ptr to vram for tiles
	# d1 num tiles in row (don't need)
	add.w d3, d0
	MAKE_VDP_ADDR d0
	or.l #VRAM_WRITE, d0
	move.l d0, VDP_CTRL

	#moveq #0, d1
	#move.l (a0), d1
  moveq #7, d7

1:rol.l #4, d2
	move.l d2, d0
	and.w #0x0f, d0
	cmp.b #0x09, d0
	bgt 2f
	add.b #0x10, d0
	bra 3f
2:add.b #0x17, d0
3:move.w d0, VDP_DATA
	dbf d7, 1b
	rts
