OUTPUT_ARCH(m68k)

MEMORY
{
	ROM (rx): ORIGIN = 0, LENGTH = 0x400000
	RAM (w): ORIGIN = 0xFF0000, LENGTH = 0x10000
}

SECTIONS
{
  .text 0x00000000:
  {
    /*build/src_md/md_header.o (.text)*/
    *(.text*)
    *(.rodata*)
  } > ROM

  .data 0xFF0000 :
  AT ( ADDR (.text) + SIZEOF (.text) )
  {
		*(.data*)
  } > RAM

  .bss 0xFF0000 + SIZEOF (.data) :
  {
    *(.bss)
  } > RAM
}