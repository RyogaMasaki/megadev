#ifndef MEGADEV__EXCEPTION_S
#define MEGADEV__EXCEPTION_S

#include "macros.s"
#include "cd_main_boot_def.h"
#include "cd_main_def.h"
#include "io_def.h"
#include "vdp_def.h"

.section .text

FUNC ex_bus_err
	move.l #strBUSERR, (err_str_ptr)
	jbra ex_group0_stack_copy

FUNC ex_addr_err
	move.l #strADDRERR, (err_str_ptr)
ex_group0_stack_copy:
  adda.l #2, sp  // skip the first word (extrended info)
	move.l (sp)+, (addr_val)
	move.w (sp)+, (op_val)
	move.w (sp)+, (sr_val)
	move.l (sp)+, (pc_val)
	jbra handle_exception

FUNC ex_ill_inst
	move.l #strILLEGAL, (err_str_ptr)
	jbra handle_exception

FUNC ex_zero_div
	move.l #strZERODIV, (err_str_ptr)
	jbra ex_group1_stack_copy

FUNC ex_chk_inst
	move.l #strCHKINST, (err_str_ptr)
	jbra ex_group1_stack_copy

FUNC ex_trapv
	move.l #strTRAPV, (err_str_ptr)
	jbra ex_group1_stack_copy

FUNC ex_priv_viol
	move.l #strPRIVV, (err_str_ptr)
	jbra ex_group1_stack_copy

FUNC ex_trace
	move.l #strTRACE, (err_str_ptr)
	jbra ex_group1_stack_copy

FUNC ex_line1010
	move.l #strL1010, (err_str_ptr)
	jbra ex_group1_stack_copy

FUNC ex_line1111
	move.l #strL1111, (err_str_ptr)
	jbra ex_group1_stack_copy

FUNC ex_spurious
	move.l #strSPUR, (err_str_ptr)

ex_group1_stack_copy:
	move.l #0, (addr_val)
	move.w #0, (op_val)
	move.w (sp)+, (sr_val)
	move.l (sp)+, (pc_val)
	jbra handle_exception


FUNC handle_exception
	ori #0x700,sr
	jbsr _VDP_CLR_NMTBL
	jbsr _LOAD_FONT_INTERN_DEFAULTS
	move.w #0, (_TILE_BASE)

	// set color to white
	move.l #0xC0020000, (VDP_CTRL)
	move.w #0x0eee, (VDP_DATA)
	
	// error titles
	move.w #0x0205, d0
	jbsr nmtbl_xy_pos
	movea.l (err_str_ptr), a1
	jbsr _PRINT_TEXT

	// PC=
	move.w #0x0306, d0
	jbsr nmtbl_xy_pos
	lea str_pc, a1
	jbsr _PRINT_TEXT

	// pc val
	move.l (pc_val), d0
	lea str_cache, a0
	jbsr printval_u32
	move.w #0x0806, d0
	jbsr nmtbl_xy_pos
	lea str_cache, a1
	jbsr _PRINT_TEXT

	// SR=
	move.w #0x0307, d0
	jbsr nmtbl_xy_pos
	lea str_sr, a1
	jbsr _PRINT_TEXT

  // sr val
	move.w (sr_val), d0
	lea str_cache, a0
	jbsr printval_u16
	move.w #0x0807, d0
	jbsr nmtbl_xy_pos
	lea str_cache, a1
	jbsr _PRINT_TEXT

	// OP=
	move.w #0x0308, d0
	jbsr nmtbl_xy_pos
	lea str_op, a1
	jbsr _PRINT_TEXT

  // op val
	move.w (op_val), d0
	lea str_cache, a0
	jbsr printval_u16
	move.w #0x0808, d0
	jbsr nmtbl_xy_pos
	lea str_cache, a1
	jbsr _PRINT_TEXT

	// ADDR=
	move.w #0x0309, d0
	jbsr nmtbl_xy_pos
	lea str_addr, a1
	jbsr _PRINT_TEXT

  // addr val
	move.l (addr_val), d0
	lea str_cache, a0
	jbsr printval_u32
	move.w #0x0809, d0
	jbsr nmtbl_xy_pos
	lea str_cache, a1
	jbsr _PRINT_TEXT

1:jbsr _UPDATE_INPUT
  and.b #PAD_START_MSK, _INPUT_P1_PRESS
	beq 1b

	jmp _ENTRY

FUNC nmtbl_xy_pos
1:move.w (_PLANE_WIDTH), d1  // d1 - tiles per row
	move.w d0, d2  // d0 - x/y offsey (upper/lower bytes of the word)
	lsr.w #8, d2  // d2 has x pos
	and.w #0xff, d0  // filter d0 so it only has y pos
	mulu d1, d0
	# d0 is now y pos * tiles per row
	# add x pos
	add.b d2, d0
	# multiply by 2 for tilemap entry size
	lsl.l #1, d0
	# TODO: make this dynamic
	# or make sure we set the nmtbl base register
	add.w #0xc000, d0

	and.l #0xffff, d0
	lsl.l #2, d0
	lsr.w #2, d0
	or.l #0x4000, d0
	swap d0
	rts


// value in d0
// lea dest in a0
FUNC printval_u8
	rol.b #4, d0
	jbsr hex_to_ascii
	move.b d1, (a0)+
	rol.b #4, d0
	jbsr hex_to_ascii
	move.b d1, (a0)+
	move.b #0xff,(a0)
	rts

FUNC printval_u16
  moveq #3, d7
1:rol.w #4, d0
  jbsr hex_to_ascii
	move.b d1, (a0)+
	dbf d7, 1b
	move.b #0xff,(a0)
	rts

FUNC printval_u32
  moveq #7, d7
1:rol.l #4, d0
  jbsr hex_to_ascii
	move.b d1, (a0)+
	dbf d7, 1b
	move.b #0xff,(a0)
	rts

hex_to_ascii:
  move.b d0, d1
	and.b #0x0f, d1
	cmp.b #0x09, d1
	bgt 2f
	add.b #0x30, d1
	rts
2:add.b #0x37, d1
  rts

.section .rodata

strBUSERR:  .ascii "BUS ERROR\xff"
.align 2
strADDRERR: .ascii "ADDRESS ERROR\xff"
.align 2
strILLEGAL: .ascii "ILLEGAL INSTRUCTION\xff"
.align 2
strZERODIV: .ascii "ZERO DIVIDE\xff"
.align 2
strCHKINST: .ascii "CHK INSTRUCTION\xff"
.align 2
strTRAPV:   .ascii "TRAPV\xff"
.align 2
strPRIVV:   .ascii "PRIVELEGE VIOLATION\xff"
.align 2
strTRACE:   .ascii "TRACE\xff"
.align 2
strL1010:   .ascii "LINE 1010 EMULATOR\xff"
.align 2
strL1111:   .ascii "LINE 1111 EMULATOR\xff"
.align 2
strSPUR:    .ascii "SPURIOUS\xff"
.align 2

str_pc:   .ascii "  PC=\xff"
.align 2
str_sr:   .ascii "  SR=\xff"
.align 2
str_addr: .ascii "ADDR=\xff"
.align 2
str_op:  .ascii "  OP=\xff"
.align 2

.section .data
err_str_ptr: .long 0
addr_val: .long 0
op_val: .word 0
sr_val: .word 0
pc_val: .long 0
str_cache: .space 9
.align 2


#endif