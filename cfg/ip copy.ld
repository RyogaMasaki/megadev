OUTPUT_ARCH(m68k)

MEMORY
{
	IP_AP (w): ORIGIN = 0xFF0000, LENGTH = 0xF700
}

SECTIONS
{
  .text 0xFFE000:
  AT ( 0xFF0000 )
  {
    *(.text*)
    *(.rodata*)
  } > IP_AP

  .data 0xFF8000:
  AT ( 0xFF0000 + SIZEOF(.text) )
  {
    *(.data*)
  } > IP_AP

  .bss 0xFF8000 + SIZEOF(.data):
  AT ( 0xFF0000 + SIZEOF(.text) + SIZEOF(.data) )
  {
    *(.bss*)
  } > IP_AP
}
