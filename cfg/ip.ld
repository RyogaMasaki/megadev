OUTPUT_ARCH(m68k)

MEMORY
{
	WORK_RAM (wx): ORIGIN = 0xFF0000, LENGTH = 0x8000
  RAM (w): ORIGIN = 0xFF8000, LENGTH = 0x6F00
}

SECTIONS
{
  .text 0xFF0000:
  {
    _TEXT_IP_INIT_START = .;
    *(.text*)
    *(.rodata*)
    _TEXT_IP_INIT_END = .;
    _TEXT_IP_INIT_SIZE = ABSOLUTE(_TEXT_IP_INIT_END - _TEXT_IP_INIT_START);
  } > WORK_RAM

  .data 0xFF8000: AT ( ADDR(.text) + SIZEOF(.text) )
  {
    *(.data*)
  } > RAM

  .bss 0xFF8000 + SIZEOF(.data): AT ( ADDR(.data) + SIZEOF(.data) )
  {
    *(.bss*)
  } > RAM


}
