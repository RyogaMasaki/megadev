OUTPUT_ARCH(m68k)

MEMORY
{
	ROM (rx): ORIGIN = 0, LENGTH = 0x400000
	RAM (w): ORIGIN = 0xFF2000, LENGTH = 0x10000
}

SECTIONS
{
  .text 0x200000:
  {
    /*build/src_cd/mmd_header.o (.text)*/
    *(.text*)
    *(.rodata*)
  } > ROM

  .data 0xFF2000 :
  AT ( ADDR (.text) + SIZEOF (.text) )
  {
		*(.data*)
  } > RAM

  .bss 0xFF2000 + SIZEOF (.data) :
  {
    *(.bss)
  } > RAM
}
