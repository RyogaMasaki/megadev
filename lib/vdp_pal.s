.section .text


.global vdp_load_pal_c
vdp_load_pal_c:
	link		a6, #0
	movea.l	8(a6), a0
	jbsr		vdp_load_pal
	unlk		a6
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
	move.l #0x1f, d7       /* 128 bytes of data (32 dwords) in palette, minus 1 for counter */
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
	lsl.l #5, d0	/* shift x5 to left to multiply subpal index to byte offset (each subpal = 32 bytes) */
	lsl.l #8, d0  /* shift x16 to move the bits into the upper word */
	lsl.l #8, d0
	ori.l #CRAM_WRITE, d0 /* set the bits for cram write */
	move.l d0, VDP_CTRL

	move.l #0x07, d7	/* 32 bytes of data (8 longs) in subpalette, minus 1 for counter */
1:move.l (a0)+, VDP_DATA
	dbra d7, 1b
	movem.l (sp)+, d7
	rts

.global vdp_load_subpal_c
vdp_load_subpal_c:
	link		a6, #0
	move.l  8(a6), d0
	movea.l	0xc(a6), a0
	jbsr		vdp_load_pal
	unlk		a6
	rts
