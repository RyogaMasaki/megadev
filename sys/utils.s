

/* Helper constants */
/* These should be OR'ed to the bit-shifted address */
.equ CRAM_WRITE,  0xC0000000
.equ VRAM_WRITE,  0x40000000
.equ VSRAM_WRITE, 0x40000010
.equ CRAM_READ,   0x00000020
.equ VRAM_READ,   0x00000000
.equ VSRAM_READ,  0x00000010

.text
setup_inputs:
	move #0x2700, sr
	move.w	#0x100, Z80_BUSREQ	| Stop Z80 
1:btst	#0, Z80_BUSREQ	| Has the Z80 stopped?
	bne.s	1b	| If not, wait.
	moveq	#0b01000000, d0	| PD6 is an output
	move.b	d0, IO_CTRL1	| Configure port A
	move.b	d0, IO_CTRL2	| Configure port B 
	move.b	d0, IO_CTRL3	| Configure port C
	move.w	#0, Z80_BUSREQ	| Restart the Z80
	move	#0x2000, sr	| Re-enable ints rts 
	rts

read_inputs:
	move.w	#0x100, Z80_BUSREQ	| Stop Z80 and wait
1:btst	#0, Z80_BUSREQ	| Has the Z80 stopped?
	bne.s	1b	| If not, wait.

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
	move.w	#0x0, Z80_BUSREQ	| Re-start the Z80
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
	drawString functions
	Draws ASCII text to scroll plane A at x/y coordinates
	String format:
		byte 1: x pos
		byte 2: y pos
		byte 3: ascii text, 0 terminated
	
	The three variations (32, 64, 128) should be called depending
	on the current horizontal scroll size as set in VDP reg 16
	INPUT:
		a0 - ptr to string
	OUTPUT:
		None
*/
.global print32
print32:
movem.l d4-d6,-(sp)
moveq #6, d4
bra print

.global print64
print64:
movem.l d4-d6,-(sp)
moveq #7, d4
bra print

.global print128
print128:
movem.l d4-d6,-(sp)
moveq #8, d4
bra print

/* Do not call this directly! Use the entry functions above */
print:	
	moveq #0, d5
	moveq #0, d6
	move.b (%a0)+, %d5	| first byte is x pos
	lsl.w #1, d5
	move.b (%a0)+, %d6	| second byte is y pos
	lsl.w d4, d6
	add.w d5, d6				| d6 contains offset from base

	/* add offset to base and format address for VDP*/
	add.l #VDP_SCROLLA_PTBL, d6
	move.l d6, d5
	
	lsr.l #8, %d6
	lsr.l #6, %d6

	lsl.l #8, %d5
	lsl.l #8, %d5

	or.l %d6, %d5
	bset #30, %d5
	bclr #31, %d5
	move.l %d5, (VDP_CTRL)
	
	/* read/send ascii data */
	moveq #0, %d6
	1:
	move.b (%a0)+, %d6
	beq 2f
	sub #0x20, %d6
	move.w %d6, (VDP_DATA)
	bra 1b
	2:
	movem.l (sp)+, d4-d6
	rts

.data
	input_p1_hold:  dc.b 0
	input_p1_press: dc.b 0
	input_p2_hold:  dc.b 0
	input_ps_press: dc.b 0

.text

