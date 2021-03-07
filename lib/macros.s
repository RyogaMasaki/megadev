/**
 * \file macros.s
 * \brief General purpose asm macros
 */

#ifndef MACROS_S
#define MACROS_S

#include "z80_def.h"

.macro FUNC name, align=2
    .section .text.asm.\name
    .global  \name
    .type   \name, @function
    .align \align
  \name:
.endm

.macro GLOBAL name, value
  .global \name
  .equ \name, \value
.endm

.macro INTERRUPT_DISABLE
  ori #0x700, sr
.endm

.macro INTERRUPT_ENABLE
  andi #0xF8FF, sr
.endm

.altmacro
.macro Z80_DO_BUSREQ
LOCAL loop
	move.w #0x100, Z80_BUSREQ
loop:
  btst #0,  Z80_BUSREQ
	bne.s	loop
.endm

.macro Z80_DO_BUSRELEASE
	move.w  #0, Z80_BUSREQ
.endm

.macro Z80_DO_RESET
    move.w  #0x000, (Z80_RESET)        // Assert reset line
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop                           // ...
    move.w  #0x100, (Z80_RESET)        // Release reset line
.endm                            // End of

/**
 * \brief Convert 16 bit VRAM address to vdpaddr format
 */
.macro TO_VDPADDR dreg
	and.l #0xffff, \dreg
	lsl.l #2, \dreg
	lsr.w #2, \dreg
	swap \dreg
.endm

/**
 * \brief Convert a value to binary coded decimal
 * \param[in] D0.w Value to convert
 * \param[out] D0.w Value as BCD
 * \break D1
 */
.macro HEX2BCD
	ext.l	d0
	divu.w	#0xa, d0
	move.b	d0, d1
	lsl.b	#4, d1
	swap	d0
	move	#0, ccr /* why?*/
	abcd	d1, d0
.endm

/**
 * \brief Push a value on to the stack
 * \param reg Register holding the value to push
 */
.macro PUSH reg
	move.l \reg, -(sp)
.endm

/**
 * \brief Pop a value from the stack
 * \param reg Register to hold the popped value
 */
.macro POP reg
	move.l  (sp)+, \reg
.endm

/**
 * \brief Push multiple values on to the stack
 * \param regs Register list
 */
.macro PUSHM regs
	movem.l \regs, -(sp)
.endm

/**
 * \brief Pop multiple values from the stack
 * \param regs Register list
 */
.macro POPM regs
	movem.l (sp)+, \regs
.endm

#endif
