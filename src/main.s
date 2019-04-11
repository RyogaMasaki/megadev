.include "boot.s"

.text

/* Very basic vblank wait loop */
.global waitVBlank
waitVBlank:
	lea vblank, %a6
	move.l (%a6), %d0
1:move.l (%a6), %d1
	cmp.l %d0, %d1
	beq 1b
	move.b #0, (%a6)
	rts 

/* VBlank */
vblank_int:
	addq.b   #1, (vblank)
	jsr read_input
	
	rte


/* Your program code starts here */
.align 2
_main:
/* Interrupts are still disabled at this point; enable them */
move    #0x2000, %sr

lea helloWorld, %a0
jsr print32

mainLoop:
	jsr waitVBlank
	move.l #0x50000003, VDP_CTRL
  move.w %d4, VDP_DATA
  add.w  #1,%d4
	jmp mainLoop

helloWorld:
	dc.b 0, 14
	.asciz "HELLO WORLD! :)"

.data
	vblank: dc.b 0
	input_state: dc.l 0

_end:
