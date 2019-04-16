.include "boot.s"

.text
.align 2

/* Your program code starts here */
_main:
	INTERRUPT_ENABLE			 | Interrupts were disabled during initialization; re-enable them
	PRINT helloworld_str, #0, #14

main_loop:
	/* wait for a vblank before we do any processing */
	jsr vblank_wait
	jsr read_inputs
	move.l (input_p1_hold), d2
	move.w #0, d0
	move.w #16, d1
	jsr printval32_long
	move.l #0x50000003, VDP_CTRL
  move.w d4, VDP_DATA
  add.w #1, d4

	jmp main_loop

/* Very basic vblank wait loop */
.global vblank_wait
vblank_wait:
	lea vblank, a6
	move.b (a6), d0
1:move.b (a6), d1
	cmp.b d0, d1
	beq 1b
	move.b #0, (a6)
	rts 

/* VBlank */
vblank_int:
	addq.b   #1, (vblank)
	rte

.section .rodata
helloworld_str:
	.asciz "HELLO WORLD "
.data
	vblank: .byte 1
_end:

