OUTPUT_ARCH(m68k)

MEMORY
{
	IP_ROM (wx): ORIGIN = 0xFF0000, LENGTH = 0x8000
  IP_RAM (w): ORIGIN = 0xFF8000, LENGTH = 0x6F00
}

SECTIONS
{
  .text 0xFF0000:
  {
    _ip_text_org = .;
    *(.text*)
    *(.rodata*)
    _ip_text_len = ABSOLUTE(. - _ip_text_org);
  } > IP_ROM

  .data 0xFF8000 : AT ( ADDR(.text) + SIZEOF(.text) )
  {
    _ip_data_org = .;
    *(.data*)
    _ip_data_len = ABSOLUTE(. - _ip_data_org);
  } > IP_RAM

  .bss 0xFF8000 + SIZEOF(.data) :
  {
    _ip_bss_org = .;
    *(.bss*)
    _ip_bss_len = ABSOLUTE(. - _ip_bss_org);
  } > IP_RAM


}
