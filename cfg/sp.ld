OUTPUT_ARCH(m68k)

SECTIONS
{
  .text 0x006000 :
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
