OUTPUT_ARCH(m68k)

MEMORY
{
  PRG_RAM (wx): ORIGIN = 0, LENGTH = 0x40000
}

SECTIONS
{
  .text 0x006000 :
  {
    *(.text*)
    *(.rodata*)
  } > PRG_RAM
  _stext = . ;

  .data :
  {
    . = ALIGN(0x10);
    *(.data*)
  }
  _sdata = . - _stext;

  .bss :
  {
    *(.bss*)
  }
  _sbss = . - _sdata;
}
