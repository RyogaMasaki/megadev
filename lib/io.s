
/* IO Ports */
.equ    IO_DATA1,		0xA10003
.equ    IO_DATA2,		0xA10005
.equ    IO_DATA3,		0xA10007
.equ    IO_CTRL1,		0xA10009
.equ    IO_CTRL2,		0xA1000B
.equ    IO_CTRL3,		0xA1000D
.equ    IO_TXDATA1,	0xA1000F
.equ    IO_RXDATA1,	0xA10011
.equ    IO_SCTRL1,	0xA10013
.equ    IO_TXDATA2,	0xA10015
.equ    IO_RXDATA2,	0xA10017
.equ    IO_SCTRL2,	0xA10019
.equ    IO_TXDATA3,	0xA1001B
.equ    IO_RXDATA3,	0xA1001D
.equ    IO_SCTRL3,	0xA1001F



/* Input bit mappings */
.equ  IN_UP,        0b00000001
.equ  IN_DOWN,      0b00000010
.equ  IN_LEFT,      0b00000100
.equ  IN_RIGHT,     0b00001000
.equ  IN_START,     0b10000000
.equ  IN_A,         0b01000000
.equ  IN_B,         0b00010000
.equ  IN_C,         0b00100000

.section .text

.global init_inputs
init_inputs:
	INTERRUPT_DISABLE
	move.w	#0x100, Z80_BUSREQ	/* Stop Z80  */
1:btst	#0, Z80_BUSREQ	      /* Has the Z80 stopped? */
	bne.s	1b	                  /* If not, wait */
	moveq	#0b01000000, d0	      /* PD6 is an output */
	move.b	d0, IO_CTRL1        /* Configure port A */
	move.b	d0, IO_CTRL2        /* Configure port B  */
	move.b	d0, IO_CTRL3        /* Configure port C */
	move.w	#0, Z80_BUSREQ	    /* Restart the Z80 */
	INTERRUPT_ENABLE
	rts

.global update_inputs
update_inputs:
  lea	input_p1_hold, a0	/* Area where joypad states are written */
	lea	0xA10003, a1	/* First joypad port */
  moveq	#1, d7
1:move.b	#0, (a1)	/* Assert /TH */
	nop  /* wait for the controller device */
	nop
	nop
	nop
  move.b	(a1), d0	/* Read back controller states. (00SA00DU) */
	lsl.b	#2, d0	/* Shift start and A into the high 2 bits */
	and.b	#0xC0, d0	/* Get only S+A buttons */
  move.b	#0x40, (a1)	/* De-assert /TH */
	nop	/* wait for controller */
	nop
	nop
	nop
  move.b	(a1), d1	/* Read back the controller states. (11CBRLDU) */
	and.b	#0x3F, d1	/* Get only CBRLDU alone */
	or.b	d1, d0	/* OR together the control states */
	not.b	d0	/* Invert the bits */
  move.b	(a0), d1	/* Get the current button press bits from RAM */
	eor.b	d0, d1	/* OR the pressed buttons with the last frame's pressed buttons */
  move.b	d0, (a0)+	/* Write the pressed bits */
	and.b	d0, d1	/* AND the bits together. */
	move.b	d1, (a0)+	/* Write the held bits */
  addq.w	#2, a1	/* Use next control port */
	dbf	d7, 1b	/* Loop until all joypads are read */
	rts
 

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
	move.w	#0x100, Z80_BUSREQ	/* stop Z80  */
1:btst	#0, Z80_BUSREQ				/* wait for stop */
	bne.s	1b
	
	/* Set comm speed; Serial in/out mode; Enable Rx interrupt */
	/*move.b	#((EXT_BAUD << 6) + 0b00111000), EXT_SCTRL*/
	move.b #0x7f, EXT_CTRL
	move.w	#0, Z80_BUSREQ	/* Restart the Z80 */
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
1:btst #1, (EXT_SCTRL)		/* check bit 1 (Rxd READY) first */
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


.section .bss
.global input_p1
input_p1:
.global input_p1_hold
input_p1_hold:
.byte 0
.global input_p1_press
input_p1_press:
.byte 0

.global input_p2
input_p2:
.global input_p2_hold
input_p2_hold:
.byte 0
.global input_p2_press
input_p2_press:
.byte 0
	
.align 2
