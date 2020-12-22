
.ifndef MEGADEV__CD_BRAM_S
.set MEGADEV__CD_BRAM_S, 1

.section .text
.include "cd_bios.s"
.include "cd_bram_macros.s"

.equ	BRMINIT,				0x0000
.equ	BRMSTAT,				0x0001
.equ	BRMSERCH,				0x0002
.equ	BRMREAD,				0x0003
.equ	BRMWRITE,				0x0004
.equ	BRMDEL,					0x0005
.equ	BRMFORMAT,			0x0006
.equ	BRMDIR,					0x0007
.equ	BRMVERIFY,			0x0008

.global bram_init
bram_init:
  lea bram_work_ram, a0
  lea bram_string_buffer, a1
  BIOS_BRMINIT
  # returns:
  #   cc    SEGA formatted RAM is present
  #   cs    Not formatted or no RAM
  #   d0.w  size of backup RAM  0x2(000) ~ 0x100(000)  bytes
  #   d1.w  0 : No RAM
  #         1 : Not Formatted
  #         2 : Other Format
  #   a1.l  pointer to display strings
	bcc 2f
	bra 3f
2:move.w #4, d1
3:rts

.global bram_find_file
bram_find_file:
BIOS_BRMSERCH
rts

.section .bss
# TODO - these don't need to be global, just testing
.global bram_string_buffer
bram_string_buffer: .space 12
.global bram_work_ram
bram_work_ram: .space 0x640


.endif
