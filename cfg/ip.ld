OUTPUT_ARCH(m68k)

MEMORY
{
	RAM (w): ORIGIN = 0xFF0000, LENGTH = 0xF700
}

SECTIONS
{
  .text 0xFF0000 :
  {
    *(.text)
  }
  _stext = . ;

  .data :
  {
    . = ALIGN(0x10);
    *(.data)
  }
  _sdata = . - _stext;

  .bss :
  {
    *(.bss)
  }
  _sbss = . - _sdata;
}
