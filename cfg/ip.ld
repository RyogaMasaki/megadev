OUTPUT_ARCH(m68k)

MEMORY
{
  /* 32kb IPX */
	IPX (wx): ORIGIN = 0xFF0000, LENGTH = 0x8000
  /* 27.75kb RAM */
  RAM (w): ORIGIN = 0xFF8000, LENGTH = 0x6F00
  /* 2kb IP */
  IP (wx): ORIGIN = 0xFFEF00, LENGTH = 0x800
}

SECTIONS
{
  .text.ip_init 0xFF0000:
  {
    _TEXT_IP_INIT_START = .;
    *(.text.ip_init)
    _TEXT_IP_INIT_END = .;
    _TEXT_IP_INIT_SIZE = ABSOLUTE(_TEXT_IP_INIT_END - _TEXT_IP_INIT_START);
  } > IPX

  .text.ip 0xFFEF00: AT ( ADDR(.text.ip_init) + SIZEOF(.text.ip_init) )
  {
    _TEXT_IP_BIN_START = ADDR(.text.ip_init) + SIZEOF(.text.ip_init);
    _TEXT_IP_START = .;
    *(.text.ip)
    _TEXT_IP_END = .;
    _TEXT_IP_SIZE = ABSOLUTE(_TEXT_IP_END - _TEXT_IP_START);
  } > IP

  .data 0xFF8000: AT ( ADDR(.text.ip) + SIZEOF(.text.ip) )
  {
    *(.data*)
  } > RAM

  .bss 0xFF8000 + SIZEOF(.data): AT ( ADDR(.data) + SIZEOF(.data) )
  {
    *(.bss*)
  } > RAM


}
