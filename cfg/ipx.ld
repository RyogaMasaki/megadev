OUTPUT_ARCH(m68k)

MEMORY
{
	IP_AP (w): ORIGIN = 0xFF0000, LENGTH = 0xF700
}

SECTIONS
{
  /* start 0x100 bytes early to account for mmd header */
  .text 0xFEFF00:
  {
    /*build/src_cd/mmd_header.o (.text)*/
    MMD_START = ABSOLUTE(.);
    *(.text*)
    *(.rodata*)
    MMD_AP_SIZE = (ABSOLUTE(.) - MMD_START) >> 2;
    
  } > IP_AP

  .data 0xFF8000:
  AT ( 0xFF0000 + SIZEOF(.text) )
  {
		*(.data*)
  } > IP_AP
  
  .bss 0xFF8000 + SIZEOF(.data):  AT ( 0xFF0000 + SIZEOF(.text) + SIZEOF(.data) )
  {
    *(.bss)
  } > IP_AP
}
