
################################################################################
# VDP DMA TRANSFER
# Macros and subroutines for doing DMA transfers
# Note that there is a bug in the hardware when usng Mega CD Word RAM or when
# using the SVP chip. In short, the source address will be off by one, starting
# the read 1 word before the actual address. The solution is to 
################################################################################

/*
	VDP_DMA_TRANSFER
	Load data to VDP via DMA using static values

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
  vdp_dma_fill_sub

	IN:
	 d0 - dest addr (VDP_ADDR formatted)
	 d1 - length
	 d2 - value
	BREAK:
	 a5
*/
.global vdp_dma_fill_sub
vdp_dma_fill_sub:
	PUSHM d0-d3/a5
	# save our interrupt status
	move.w sr, -(sp)

	lea VDP_CTRL, a5

	# length is counted in words, so divide by 2...
	lsr.l #1, d1
	and.l #0x7fffffff, d0

	INTERRUPT_DISABLE

	# load dma length
	move.w #0x9300, d3
	move.b d1, d3
	swap d3
	move.w #0x9400, d3
	lsr.w #8, d1
	move.b d1, d3
	move.l d3, (a5)

	# set vram fill
	move.w #0x9500, (a5)
	move.w #0x9600, (a5)
	move.w #0x9780, (a5)

	# set dest addr
	move.l d0, (a5)

	Z80_BUSREQ

	# setup fill value and trigger dma write
	# move fill value to upper half of word
	lsl.w #8, d2
	move.w d2, (VDP_DATA)

	Z80_BUSRELEASE

	move.w (sp)+,sr
	POPM d0-d3/a5

	rts

/*
	vdp_dma_transfer_sub
	Load data to VDP via DMA using dynamic values

	IN:
	 d0 - source addr
	 d1 - length
	 d2 - dest addr (VDP_ADDR formatted)
	BREAK:
	 a5
*/
.global vdp_dma_transfer_sub
vdp_dma_transfer_sub:
	PUSHM d0-d3/a5
	# save our interrupt status
	move.w sr, -(sp)

	lea VDP_CTRL, a5

	# enable dma
	#move.w #0x811d, (a5)
	
	# length/source are counted in words, so divide by 2...
	lsr.l #1, d1
	lsr.l #1, d0
	and.l #0x7fffffff, d0

	INTERRUPT_DISABLE
	# load dma length
	move.w #0x9300, d3
	move.b d1, d3
	swap d3
	move.w #0x9400, d3
	lsr.w #8, d1
	move.b d1, d3
	move.l d3, (a5)
	
	# load dma source address
	move.w #0x9500, d3
	move.b d0, d3
	swap d3
	lsr.l #8, d0
	move.w #0x9600, d3
	move.b d0, d3
	move.l d3, (a5)
	lsr.l #8, d0
	move.w #0x9700, d3
	move.b d0, d3
	move.w d3, (a5)

	Z80_BUSREQ

	# set address and trigger dma write
	move.w d2, (dma_trigger)
	swap d2
	move.w d2, (a5)
	move.w (dma_trigger), (a5)

	# disable dma
	#move.w #0x8119, (a5)

	Z80_BUSRELEASE

	move.w (sp)+,sr
	POPM d0-d3/a5
	rts
