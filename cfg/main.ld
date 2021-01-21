OUTPUT_ARCH(m68k)

/* MMD Binary Layout
  The following should be defines as globals in your MMD program:
	MMD_DEST - This is the location to which your MMD program (minus the 0x100
	header) should be moved after it has been loaded into Word RAM. If it should
	run from Word RAM, where it was loaded, set this to 0.
	MMD_TEXT_ORIGIN - This is the base location from where your program will run.
	It should match MMD_DEST *IF* that value is not set to 0. If it is set to 0,
	set ORIGIN to 0x200100 (Word RAM) - the 0x100 accounts for the header space.
	MMD_TEXT_LENGTH - The full size of the memory block in which your program
	will run. This is NOT the length of the text section! (We need to think 
	about renaming things...) For example, if you are running from Word RAM,
	this should be (0x40000 - 0x100), for the whole 2M block minus the header
	space. 
	MMD_DATA_ORIGIN - The base location for RAM storage
	MMD_DATA_LENGTH - The size of the block for RAM storage; similar notes as the
	LENGTH section above
	MMD_TEXT_SZ - This is the size of the program data (text section)
*/

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
		LONG(HINT)
		LONG(VINT)
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

  .data MMD_DATA_ORIGIN : AT ( ADDR(.header) + SIZEOF(.header) + SIZEOF(.text) )
  {
		*(.data*)
  } > MMD_DATA

	.bss :
	{
		*(.bss*)
	} > MMD_DATA

}
