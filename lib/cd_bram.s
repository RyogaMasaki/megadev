
.ifndef MEGADEV__CD_BRAM_S
.set MEGADEV__CD_BRAM_S, 1

.section .text

.equ	BRMINIT,				0x0000
.equ	BRMSTAT,				0x0001
.equ	BRMSERCH,				0x0002
.equ	BRMREAD,				0x0003
.equ	BRMWRITE,				0x0004
.equ	BRMDEL,					0x0005
.equ	BRMFORMAT,			0x0006
.equ	BRMDIR,					0x0007
.equ	BRMVERIFY,			0x0008

bram_init:
lea bram_scratch, a0
lea bram_strings, a1
BIOS_BRMINIT
rts

bram_find_file:
BIOS_BRMSEARCH
rts

.section .bss
bram_strings: .space 12
bram_scratch: .space 0x640


.endif
