/*
	This is the initial Sub CPU side code
  This example is too simple to have anything going on here!
	Check out one of the other examples for something more substantial.
*/

#include "macros.s"
#include "cd_sub_def.h"
#include "cd_sub_macros.s"
#include "cd_sub_bios_macros.s"

.section .text

sp_header:
.asciz	"MAIN       "
.word		0x0100
.word		0
.long		0
.long		_sp_text_len				/*module size - size of text section*/
.long		sp_jmptbl-sp_header		/*start address - address of jump table*/
.long		_sp_ram_len			/*work ram size - size of data + bss*/

sp_jmptbl:
.word		sp_init-sp_jmptbl
.word		sp_null-sp_jmptbl
.word		sp_null-sp_jmptbl
.word		sp_null-sp_jmptbl
.word		0

sp_init:
	CLEAR_COMM_REGS
  rts

sp_null:
  rts

