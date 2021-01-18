.section .text
/* External interrupt */
.global _EXINT
_EXINT:
/* jsr ext_rx */
rte

/* HBLANK interrupt */
.global HINT
HINT:
rte

/* VBLANK interrupt */
.global VINT
VINT:
jmp vblank_int

