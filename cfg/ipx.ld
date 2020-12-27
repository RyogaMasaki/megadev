INCLUDE memconfig.ld

OUTPUT_ARCH(m68k)

MEMORY
{
	IPX (w): ORIGIN = 0xFF0000, LENGTH = 0xF700
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
    
  } > IPX

  .data IPX_RAM_ORIGIN : AT ( 0xFF0000 + SIZEOF(.text) )
  {
		*(.data*)
    *(.bss)
  } > IPX

}
