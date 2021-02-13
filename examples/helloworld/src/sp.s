
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
.word		sp_main-sp_jmptbl
.word		sp_vint-sp_jmptbl
.word		sp_userdefined-sp_jmptbl
.word		0

sp_vint:
  rts




sp_init:
	lea			drvinit_tracklist, a0		/* setup the BIOS DRVINIT call */
	BIOS_DRVINIT
0:BIOS_CDBSTAT
	andi.b	#0xf0, (_CDSTAT).w		/* loop until done reading TOC */
	bne			0b
	CLEAR_COMM_REGS
	//move.b #0, (GA_COMFLAGS+1)
  rts

drvinit_tracklist:
	.byte 1, 0xff

sp_main:
  rts

sp_userdefined:
  rts

.section .bss
test_var: .long 0

