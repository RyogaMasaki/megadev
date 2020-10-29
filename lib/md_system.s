
/* Version register */
.equ    VERSION,	  0xA10001  /* 16/32 bit r */

/* TMSS Register */
.equ		IO_TMSS,		0xA14000

.section .text

tmss_init:
	# check hardware version
	move.b	VERSION, d0
	andi.b	#0x0f, d0
	# version 0, skip TMSS
	beq	1f
	# write 'SEGA' string to TMSS port
	move.l	#0x53454741, IO_TMSS
1:rts

/*
	md_standard_init
	Standard RAM clearing and other initialization
	This should NOT be used for Mega CD games!
*/
.global md_standard_init
md_standard_init:
	INTERRUPT_DISABLE
/*	tst.l (IO_CTRL1-1).l
	bne 1f
	tst.w (IO_CTRL3-1).l
1:bne md_post_init
*/
	jsr tmss_init
	jsr load_z80_init_program
	# init VDP

	INTERRUPT_ENABLE
	rts
