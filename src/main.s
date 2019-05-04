.include "boot.s"

.text
.align 2

/* Your program code starts here */
_main:
	INTERRUPT_ENABLE			 | Interrupts were disabled during initialization; re-enable them
	
	PRINT helloworld_str, #0, #13

	jsr init_ext

main_loop:
	jsr vblank_wait		| wait for a vblank before we move into game processing
	jsr read_inputs		| read current inputs from the controller

	move.l #0x50000003, VDP_CTRL
  move.w d4, VDP_DATA
  add.w #1, d4

	moveq #0, d0
	moveq #1, d1
	move.b (IO_CTRL3), d2
	jsr printval32_word

	moveq #0, d0
	moveq #2, d1
	move.b (IO_SCTRL3), d2
	jsr printval32_word
	

	moveq #0, d0
	moveq #3, d1
	move.b (IO_RXDATA3), d2
	jsr printval32_word

		moveq #0, d0
	moveq #4, d1
	move.b (IO_TXDATA3), d2
	jsr printval32_word

	lea megadrivers_str, a3
	move.w #22, d7
1:move.b (a3)+, d0
	jsr ext_tx
	dbra d7, 1b

	jmp main_loop

.global vblank_wait
vblank_wait:
	lea vblank, a6		| check our vblank flag
1:move.b (a6), d0		| MOVE will set Z flag if the value is 0
	beq 1b
	move.b #0, (a6)		| reset flag and return to processing
	rts 

vblank_int:
	addq.b   #1, (vblank)	| vblank occurred; set flag
	rte

.section .rodata
megadrivers_str:
	.ascii "FOR MEGADRIVERS CUSTOM\n"
fireheartpre_str:
	.asciz "NOW IS TIME TO THE"
fireheart_str:
	.asciz "68000 HEART ON FIRE!"
helloworld_str:
	.asciz "HELLO WORLD :)"

.data
	vblank: .byte 1
	dummy2: .byte 1
	testval: .word 1

