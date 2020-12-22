OUTPUT_ARCH(m68k)

MEMORY
{
	WORDRAM (w): ORIGIN = 0x200000, LENGTH = 0x200000
	WORKRAM (w): ORIGIN = 0xFF0000, LENGTH = 0xef00
}

SECTIONS
{
  .text 0x200000:
  {
    MMD_START = ABSOLUTE(.);
    /*build/src_cd/mmd_header.o (.text)*/
    *(.text*)
    *(.rodata*)
    MMD_AP_SIZE = (ABSOLUTE(.) - MMD_START) >> 2;
    
  } > WORDRAM

  .data 0xFFA000 : AT ( ADDR (.text) + SIZEOF (.text) )
  {
		*(.data*)
  } > WORKRAM

  .bss 0xFFA000 + SIZEOF (.data) : AT ( ADDR(.data) + SIZEOF(.data) )
  {
    *(.bss*)
  } > WORKRAM
}
