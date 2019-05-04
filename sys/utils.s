.text

/* Helper constants */
/* These should be OR'ed to the VDP compatible bit-shifted address */
.equ CRAM_WRITE,  0xC0000000
.equ VRAM_WRITE,  0x40000000
.equ VSRAM_WRITE, 0x40000010
.equ CRAM_READ,   0x00000020
.equ VRAM_READ,   0x00000000
.equ VSRAM_READ,  0x00000010


/*
	init_ext
	Sets up port 

	INPUT:
		None
	OUTPUT:
		d0 - byte value read from external device
*/
init_ext:
	INTERRUPT_DISABLE
	move.w	#0x100, Z80_BUSREQ	| stop Z80 
1:btst	#0, Z80_BUSREQ				| wait for stop
	bne.s	1b
	
	/* Set comm speed; Serial in/out mode; Enable Rx interrupt */
	move.b	#((EXT_BAUD << 6) + 0b00111000), EXT_SCTRL
	move.b #0x7f, EXT_CTRL
	move.w	#0, Z80_BUSREQ	| Restart the Z80
	INTERRUPT_ENABLE
	rts


/*
	ext_rx
	Reads a byte from the external device

	INPUT:
		None
	OUTPUT:
		d0 - byte value received
*/
/* TODO: How does RERR play into this? */
ext_rx:
	movem.l d0-d7/a0-a6,-(sp)
1:btst #1, (EXT_SCTRL)		| check bit 1 (Rxd READY) first
	beq 1b
	
	moveq #0, d0 
	move.b (EXT_RXDATA), d0

	movem.l (sp)+, d0-d7/a0-a6
	rts

/*
	ext_tx
	Transmits a byte to the external device

	INPUT:
		None
	OUTPUT:
		d0 - byte value to transmit
*/
ext_tx:
	movem.l d1, -(sp)
2:move.b (EXT_SCTRL), d1
	btst #0, d1
	bne 2b
	move.b d0, EXT_TXDATA
	movem.l (sp)+, d1
	rts

/*
	init_inputs
	Loads a full system palette (64 colors) into CRAM

	INPUT:
		a0 - ptr to palette data
	OUTPUT:
		None
*/
.global init_inputs
init_inputs:
	INTERRUPT_DISABLE
	move.w	#0x100, Z80_BUSREQ	| Stop Z80 
1:btst	#0, Z80_BUSREQ	| Has the Z80 stopped?
	bne.s	1b	| If not, wait.
	moveq	#0b01000000, d0	| PD6 is an output
	move.b	d0, IO_CTRL1	| Configure port A
	move.b	d0, IO_CTRL2	| Configure port B 
	move.b	d0, IO_CTRL3	| Configure port C
	move.w	#0, Z80_BUSREQ	| Restart the Z80
	INTERRUPT_ENABLE
	rts

.global read_inputs
read_inputs:
  lea	input_p1_hold, a0	| Area where joypad states are written
	lea	0xA10003, a1	| First joypad port
  moveq	#1, d7
1:move.b	#0, (a1)	| Assert /TH
	nop  | wait for the controller device
	nop
	nop
	nop
  move.b	(a1), d0	| Read back controller states. (00SA00DU)
	lsl.b	#2, d0	| Shift start and A into the high 2 bits
	and.b	#0xC0, d0	| Get only S+A buttons
  move.b	#0x40, (a1)	| De-assert /TH
	nop	| wait for controller
	nop
	nop
	nop
  move.b	(a1), d1	| Read back the controller states. (11CBRLDU)
	and.b	#0x3F, d1	| Get only CBRLDU alone
	or.b	d1, d0	| OR together the control states
	not.b	d0	| Invert the bits
  move.b	(a0), d1	| Get the current button press bits from RAM
	eor.b	d0, d1	| OR the pressed buttons with the last frame's pressed buttons
  move.b	d0, (a0)+	| Write the pressed bits
	and.b	d0, d1	| AND the bits together.
	move.b	d1, (a0)+	| Write the held bits
  addq.w	#2, a1	| Use next control port
	dbf	d7, 1b	| Loop until all joypads are read
	rts
 
/*
	vdp_load_pal
	Loads a full system palette (64 colors) into CRAM

	INPUT:
		a0 - ptr to palette data
	OUTPUT:
		None
*/
.global vdp_load_pal
vdp_load_pal:
	/* vdp auto increment should be set to 2 already */
	movem.l d7, -(sp)
	move.l #CRAM_WRITE, VDP_CTRL
	move.l #0x1f, d7       | 128 bytes of data (32 dwords) in palette, minus 1 for counter
1:move.l (a0)+, VDP_DATA
	dbra d7, 1b
	movem.l (sp)+, d7
	rts

/*
	vdp_load_subpal
	Loads a subpalette (16 colors) into CRAM

	INPUT:
		a0 - ptr to palette data
		d0 - subpalette index (valid values: 0 to 3)
	OUTPUT:
		None
*/
.global vdp_load_subpal
vdp_load_subpal:
	movem.l d7, -(sp)
	lsl.l #5, d0	| shift x5 to left to multiply subpal index to byte offset (each subpal = 32 bytes) */
	lsl.l #8, d0  | shift x16 to move the bits into the upper word
	lsl.l #8, d0
	ori.l #CRAM_WRITE, d0 | set the bits for cram write
	move.l d0, VDP_CTRL

	move.l #0x07, d7	| 32 bytes of data (8 dwords) in subpalette, minus 1 for counter
1:move.l (a0)+, VDP_DATA
	dbra d7, 1b
	movem.l (sp)+, d7
	rts

/*
	print
	Prints ASCII text to scroll plane A at x/y coordinates
	String format:
		byte 1: x pos
		byte 2: y pos
		byte 3: ascii text, 0 terminated

	Note that plane_width must be set properly (match the value of VDP register
	0x10) to correctly place the text with X/Y coords
	INPUT:
		d0 - x pos
		d1 - y pos
		a0 - ptr to string
	OUTPUT:
		None
*/
print:
	movem.l d0-d3,-(sp)
	move.b (plane_width), d2	| need to know the width of chrs in a row on the plane
	andi.b #0x3, d2
	cmp.b #0x2, d2
	blt 1f	| 32 chrs
	beq 2f	| 64 chrs
	moveq #8, d3 | 128 chrs
	bra 4f
1:moveq #6, d3
	bra 4f
2:moveq #7, d3

4:jsr set_printxy_offset
	
	/* read/send ascii data */
	moveq #0, d0
1:move.b (a0)+, d0
	beq 2f
	sub #0x20, d0
	move.w d0, (VDP_DATA)
	bra 1b
2:movem.l (sp)+, d0-d3
	rts

/*
	print_value functions
	Prints ASCII text to scroll plane A at x/y coordinates based
	on a value from a given address
	
	The three variations (32, 64, 128) should be called depending
	on the current horizontal scroll size as set in VDP reg 16
	INPUT:
		d0 - x pos
		d1 - y pos
		d2 - value to print
	OUTPUT:
		None
*/

.global printval32_byte
printval32_byte:
	moveq #6, d3
	bra print_value_byte

.global printval64_byte
printval64_byte:
	moveq #7, d3
	bra print_value_byte

.global printval128_byte
printval128_byte:
	moveq #8, d3
	bra print_value_byte

print_value_byte:
	jsr set_printxy_offset

	move.w #0x1, d7
1:rol.b #4, d2
	move.b d2, d1
	and.w #0x0f, d1
	cmp.b #0x09, d1
	bgt 2f
	add.b #0x10, d1
	bra 3f
2:add.b #0x17, d1
3:move.w d1, VDP_DATA
	dbf d7, 1b
	rts

.global printval32_word
printval32_word:
	moveq #6, d3
	bra print_value_word

.global printval64_word
printval64_word:
	moveq #7, d3
	bra print_value_word

.global printval128_word
printval128_word:
	moveq #8, d3
	bra print_value_word

print_value_word:
	jsr set_printxy_offset

	move.w #0x3, d7
1:rol.w #4, d2
	move.w d2, d1
	and.w #0x0f, d1
	cmp.b #0x09, d1
	bgt 2f
	add.b #0x10, d1
	bra 3f
2:add.b #0x17, d1
3:move.w d1, VDP_DATA
	dbf d7, 1b
	rts

.global printval32_long
printval32_long:
	moveq #6, d3
	bra print_value_long

.global printval64_long
printval64_long:
	moveq #7, d3
	bra print_value_long

.global printval128_long
printval128_long:
	moveq #8, d3
	bra print_value_long

print_value_long:
	jsr set_printxy_offset

	move.w #0x7, d7
1:rol.l #4, d2
	move.l d2, d1
	and.w #0x0f, d1
	cmp.b #0x09, d1
	bgt 2f
	add.b #0x10, d1
	bra 3f
2:add.b #0x17, d1
3:move.w d1, VDP_DATA
	dbf d7, 1b
	rts

/*
	set_printxy_offset
	Calculates and sets the correct offset in VRAM for a given X/Y coord
*/
set_printxy_offset:
	andi.b #0xff, d0	| d0 = xpos
	andi.b #0xff, d1	| d1 = ypos
	lsl.w #1, d0			| each name pattern entry is 2 bytes; shift x offset to multiply by 2
	lsl.w d3, d1			| d3 = playfield width (32,64,128)
	add.w d1, d0			| d0 now contains offset from nametable base

	add.l #VDP_SCROLLA_PTBL, d0
	move.l d0, d1

	/* Shift things around to make the VDP happy */
	lsr.l #8, d0
	lsr.l #6, d0

	lsl.l #8, d1
	lsl.l #8, d1

	or.l d0, d1
	bset #30, d1
	bclr #31, d1
	move.l d1, VDP_CTRL
	rts

.data
	dummy:					.byte 1
	plane_width:		.byte 1
	input_p1_hold:  .byte 1
	input_p1_press: .byte 1
	input_p2_hold:  .byte 1
	input_p2_press: .byte 1
	