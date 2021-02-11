OUTPUT_ARCH(m68k)

MEMORY
{
	MODULE_ROM (wx): ORIGIN = MODULE_ROM_ORIGIN, LENGTH = MODULE_ROM_LENGTH
	MODULE_RAM (w): ORIGIN = MODULE_RAM_ORIGIN, LENGTH = MODULE_RAM_LENGTH
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
		LONG(HINT)
		LONG(VINT)
		. = 0x100;
	} > MODULE_ROM

  .text MODULE_ROM_ORIGIN : AT ( ADDR(.header) + SIZEOF(.header) )
  {
		/* MMD header */
    MMD_START = ABSOLUTE(.);
		*(.main*)
    *(.text*)
    *(.rodata*)
    MMD_TEXT_SZ = (ABSOLUTE(.) - MMD_START) >> 2;
  } > MODULE_ROM

  .data MODULE_RAM_ORIGIN : AT ( ADDR(.header) + SIZEOF(.header) + SIZEOF(.text) )
  {
		*(.data*)
  } > MODULE_RAM

	.bss :
	{
		*(.bss*)
	} > MODULE_RAM

}
