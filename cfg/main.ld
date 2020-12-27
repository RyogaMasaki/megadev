OUTPUT_ARCH(m68k)

MEMORY
{
	/* Mega Drive RAM */
	/* 0xFFF700 and up is used by the system - BIOS, stack, vectors, etc*/
	MMD_TEXT (w): ORIGIN = MMD_TEXT_ORIGIN, LENGTH = MMD_TEXT_LENGTH
	MMD_DATA (w): ORIGIN = MMD_DATA_ORIGIN, LENGTH = MMD_DATA_LENGTH
}

SECTIONS
{
	ENTRY(main)
	.header :
	{
		SHORT(0)
		LONG(MMD_DEST)
		SHORT(MMD_TEXT_SZ)
		LONG(main)
		LONG(_HINT)
		LONG(_VINT)
		. = 0x100;
	} > MMD_TEXT

  .text MMD_TEXT_ORIGIN : AT ( ADDR(.header) + SIZEOF(.header) )
  {
		/* MMD header */
    MMD_START = ABSOLUTE(.);
    *(.text*)
    *(.rodata*)
    MMD_TEXT_SZ = (ABSOLUTE(.) - MMD_START) >> 2;
  } > MMD_TEXT

  .data : AT ( ADDR(.header) + SIZEOF(.header) + SIZEOF(.text) )
  {
		*(.data*)
  } > MMD_DATA

	.bss :
	{
		*(.bss*)
	} > MMD_DATA

}
