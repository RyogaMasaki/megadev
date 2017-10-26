
OUTPUT_ARCH(m68k)

SECTIONS
{
    . = 0x00000000;
    
    .text : {
        *(.text);
    }

    . = 0x00FF0000;

    .data : {
        *(.data);
    }

    .bss : {
        *(.bss);
    }
}
