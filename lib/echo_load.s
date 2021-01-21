/**
 * echo_load.s
 * Echo sound driver
 */

#ifndef MEGADEV__ECHO_LOAD_S
#define MEGADEV__ECHO_LOAD_S

.section .rodata

echo_driver: .incbin "echo_z80.bin"
.global echo_driver
echo_driver_sz: .word . - echo_driver
.global echo_driver_sz

.align 2

#endif
