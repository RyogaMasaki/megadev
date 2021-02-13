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
		SHORT(_mod_text_len >> 2)
		LONG(main)
		LONG(HINT)
		LONG(VINT)
		. = 0x100;
	} > MODULE_ROM

  .text MODULE_ROM_ORIGIN : AT ( ADDR(.header) + SIZEOF(.header) )
  {
		/* MMD header */
    _mod_text_org = .;
		*(.main*)
    *(.text*)
    *(.rodata*)
    _mod_text_len = ABSOLUTE(. - _mod_text_org);
  } > MODULE_ROM

  .data MODULE_RAM_ORIGIN : AT ( ADDR(.header) + SIZEOF(.header) + SIZEOF(.text) )
  {
		_mod_data_org = .;
		*(.data*)
		_mod_data_len = ABSOLUTE(. - _mod_data_org);
  } > MODULE_RAM

	.bss :
	{
		_mod_bss_org = .;
		*(.bss*)
		_mod_bss_len = ABSOLUTE(. - _mod_bss_org);
	} > MODULE_RAM


}
