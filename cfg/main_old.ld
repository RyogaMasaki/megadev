OUTPUT_ARCH(m68k)

MEMORY
{
	MMD_TEXT (w): ORIGIN = MMD_TEXT_ORIGIN, LENGTH = MMD_TEXT_LENGTH
	MMD_DATA (w): ORIGIN = MMD_DATA_ORIGIN, LENGTH = MMD_DATA_LENGTH
}

SECTIONS
{
  .text :
  {
    MMD_START = ABSOLUTE(.);
    /*build/src_cd/mmd_header.o (.text)*/
    *(.text*)
    *(.rodata*)
    MMD_TEXT_SZ = (ABSOLUTE(.) - MMD_START) >> 2;
    
  } > MMD_TEXT

  .data : AT ( ADDR (.text) + SIZEOF (.text) )
  {
		*(.data*)
		*(.bss*)
  } > MMD_DATA

}
