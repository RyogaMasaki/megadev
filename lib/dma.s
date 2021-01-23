/**
 * \file dma.s
 * Direct Memory Access (DMA) functions
 */

#ifndef MEGADEV__DMA_H
#define MEGADEV__DMA_H

#include "macros.s"

/*
################################################################################
# VDP DMA TRANSFER
# Macros and subroutines for doing DMA transfers
# Note that there is a bug in the hardware when usng Mega CD Word RAM or when
# using the SVP chip. In short, the source address will be off by one, starting
# the read 1 word before the actual address. The solution is to 
################################################################################
*/

.global dma_wait
dma_wait:
1:move.w (VDP_CTRL), d6
	and.w #DMA_IN_PROGRESS, d6
	beq 2f
	nop
	bra 1b
2:rts


/*
--------------------------------------------------------------------------------
	VDP_DMA_TRANSFER
	Load data to VDP via DMA using static values
--------------------------------------------------------------------------------

	BREAK:
	 a5
*/
/*
.macro VDP_DMA_TRANSFER source,dest,length,ram
	lea	(VDP_CTRL).l,a5
	VDP_ADDR \dest,\ram,DMA
	move.l	#((0x9400|((((\length)>>1)&0xFF00)>>8))<<16)|(0x9300|(((\length)>>1)&0xFF)),(a5)
	move.l	#((0x9600|((((\source)>>1)&0xFF00)>>8))<<16)|(0x9500|(((\source)>>1)&0xFF)),(a5)
	move.w	#0x9700|(((((\source)>>1)&0xFF0000)>>16)&0x7F),(a5)
	move.w	#((vdp_cmd>>16)&0xFFFF),(a5)
	move.w	#(vdp_cmd&0xFFFF),(DMA_trigger_word).w
	# we want to write the last word from RAM due to a bug in the hardware
	# see the documentation for more info
	move.w	(DMA_trigger_word).w,(a5)
.endm
*/

/*
--------------------------------------------------------------------------------
vdp_dma_fill_sub
--------------------------------------------------------------------------------
	IN:
	 d0 - value
	 d1 - length (bytes)
	 d2 - dest addr (VDP_ADDR formatted)
	BREAK:
	 a5
--------------------------------------------------------------------------------
*/
.global vdp_dma_fill_sub
vdp_dma_fill_sub:
	PUSHM d0-d3/a5
	# save our interrupt status
	move.w sr, -(sp)

	# will be re-enabled by restoring SR (if it was enabled to start)
	INTERRUPT_DISABLE

	jsr dma_wait

	lea VDP_CTRL, a5

	# length is counted in words, so divide by 2...
	#lsr.l #1, d1
	# TODO this subtraction is a test...
	subq #1, d1
# TODO also a test, set autoinc to 1
	move.w #(VDP_REG0F|0x01), (a5)
	# load dma length
	move.w #VDP_REG13, d3
	move.b d1, d3
	swap d3
	move.w #VDP_REG14, d3
	lsr.w #8, d1
	move.b d1, d3
	move.l d3, (a5)

	# set vram fill settings in src
	move.w #VDP_REG15, (a5)
	move.w #VDP_REG16, (a5)
	move.w #(VDP_REG17 | 0x80), (a5)

	# set dest addr
	and.l #0x7fffffff, d2
	move.l d2, (a5)

	Z80_BUSREQUEST

	# setup fill value and trigger dma write
	# move fill value to upper half of word
	lsl.w #8, d0
	move.w d0, -(sp)
	move.w (sp)+, (VDP_DATA)

jsr dma_wait

move.w #(VDP_REG0F|0x02), (a5)

	Z80_BUSRELEASE

	move.w (sp)+,sr
	POPM d0-d3/a5

	rts

/*
--------------------------------------------------------------------------------
  vdp_dma_copy_sub
--------------------------------------------------------------------------------
	IN:
	 d0 - source addr
	 d1 - length
	 d2 - dest addr (VDP_ADDR formatted)
	BREAK:
	 a5
*/
.global vdp_dma_copy_sub
vdp_dma_copy_sub:
	PUSHM d0-d3/a5
	# save our interrupt status
	move.w sr, -(sp)

	# will be re-enabled by restoring SR (if it was enabled to start)
	INTERRUPT_DISABLE

	jsr dma_wait

	lea VDP_CTRL, a5	

	# length is in bytes now!
	#lsr.l #1, d1
	# only 16 bit source addr
	and.l #0xffff, d0
	# set CD4 (vram copy) bit on dest addr
	or.l #0x40, d2

	# load dma length
	move.w #VDP_REG13, d3
	move.b d1, d3
	swap d3
	move.w #VDP_REG14, d3
	lsr.w #8, d1
	move.b d1, d3
	move.l d3, (a5)
	
	# load dma source address
	move.w #VDP_REG15, d3
	move.b d0, d3
	swap d3
	lsr.l #8, d0
	move.w #VDP_REG16, d3
	move.b d0, d3
	move.l d3, (a5)
	# reg 17 takes a constant for vram copy
	move.w #(VDP_REG17 | 0xc0), (a5)

	# set auto inc to 1 for internal VDP memory work...?
	# TODO - Should we do this with DMA fill as well?
	move.w #(VDP_REG0F|0x01), (a5)
	Z80_BUSREQUEST

	# set address and trigger dma write
	#move.l d2, (a5)
	move.w d2, -(sp)
	swap d2
	move.w d2, (a5)
	move.w (sp)+, (a5)
	

	# disable dma
	#move.w #0x8119, (a5)

	jsr dma_wait


	Z80_BUSRELEASE
	
	move.w #(VDP_REG0F|0x02), (a5)


	move.w (sp)+, sr
	POPM d0-d3/a5
  rts


/*
--------------------------------------------------------------------------------
	vdp_dma_transfer_sub
	Load data to VDP via DMA using dynamic values
--------------------------------------------------------------------------------
	IN:
	 d0 - source addr
	 d1 - length
	 d2 - dest addr (VDP_ADDR formatted)
	BREAK:
	 d6,a5
*/
.global vdp_dma_transfer_sub
vdp_dma_transfer_sub:
	PUSHM d0-d3/a1/a5
	# save our interrupt status
	move.w sr, -(sp)

	# will be re-enabled by restoring SR (if it was enabled to start)
	INTERRUPT_DISABLE

	jsr dma_wait

	lea VDP_CTRL, a5
	# a1 will be used at the end for the final read
	movea.l d0, a1

	# enable dma
	#move.w #0x811d, (a5)
	
	# length/source are counted in words, so divide by 2...
	lsr.l #1, d1
	lsr.l #1, d0
	and.l #0x7fffffff, d0

	
	
	# load dma length
	move.w #VDP_REG13, d3
	move.b d1, d3
	swap d3
	move.w #VDP_REG14, d3
	lsr.w #8, d1
	move.b d1, d3
	move.l d3, (a5)
	
	# load dma source address
	move.w #VDP_REG15, d3
	move.b d0, d3
	swap d3
	lsr.l #8, d0
	move.w #VDP_REG16, d3
	move.b d0, d3
	move.l d3, (a5)
	lsr.l #8, d0
	move.w #VDP_REG17, d3
	move.b d0, d3
	move.w d3, (a5)

	Z80_BUSREQUEST

	# set address and trigger dma write
	# put trigger on stack so it comes from RAM (per documentation)
	move.w d2, -(sp)
	swap d2
	move.w d2, (a5)
	move.w (sp)+, (a5)

	# disable dma
	#move.w #0x8119, (a5)

	# per the documentation, we want to rewrite the first two words
	# through the VDP port, just in case
	swap d2
	# remove the DMA flag
  and.w #0xff7f, d2
	move.l d2, (a5)
	move.l (a1), VDP_DATA

	Z80_BUSRELEASE

	move.w (sp)+,sr
	POPM d0-d3/a1/a5
	rts

/*
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
	d0 - type (xfer/fill/copy)
	d1 - src OR value
	d2 - length
	d3 - dest (vdp formatted)
	break:
	d4, a5
*/
.global dma_enqueue
dma_enqueue:
  lea dma_queue, a5
	move.w (dma_queue_write_idx), d4
	beq 1f
	mulu #12, d4
	adda d4, a5
1:move.l d1, (a5)+
	move.w d2, (a5)+
	move.l d3, (a5)+
	move.w d0, (a5)+
	# move to next queue index
	addq #1, (dma_queue_write_idx)
  rts

/*
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
*/
.global dma_process_queue
dma_process_queue:
	PUSHM d0-d4/d6-d7/a5
	INTERRUPT_DISABLE
	move.w (dma_queue_write_idx), d7
	beq 5f
	subq #1, d7
	lea dma_queue, a5

1:move.l (a5)+, d0
  move.w (a5)+, d1
	move.l (a5)+, d2
	move.w (a5)+, d4
	beq 2f
	# TODO make this btst instead of cmp ?
	cmp #1, d4
	bne 3f
	# 1 - dma fill
	jsr vdp_dma_fill_sub
	bra 4f
3:# 2 - dma copy
  jsr vdp_dma_copy_sub
	bra 4f
2:jsr vdp_dma_transfer_sub
4:dbf d7, 1b
	move.l #0, (dma_queue_write_idx)
	INTERRUPT_ENABLE
5:POPM d0-d4/d6-d7/a5
  rts

.equ dma_queue_size, 0x10

# u32 src/value, u16 length, u32 dest, u16 type = 12 bytes
.section .bss
dma_queue_write_idx: .word 0
.global dma_queue
dma_queue: .fill (20 * dma_queue_size)

#endif
