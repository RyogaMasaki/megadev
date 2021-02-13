OUTPUT_ARCH(m68k)

MEMORY
{
  PRG_RAM (wx): ORIGIN = 0, LENGTH = 0x40000
}

SECTIONS
{
  .text 0x006000 :
  {
    _sp_text_org = .;
    *(.text*)
    *(.rodata*)
    _sp_text_len = ABSOLUTE(. - _sp_text_org);
  } > PRG_RAM

  .data :
  {
    _sp_data_org = .;
    *(.data*)
    _sp_data_len = ABSOLUTE(. - _sp_data_org);
  } > PRG_RAM

  .bss :
  {
    _sp_bss_org = .;
    *(.bss*)
    _sp_bss_len = ABSOLUTE(. - _sp_bss_org);
  } > PRG_RAM
  _sp_ram_len = _sp_data_len + _sp_bss_len;
}
