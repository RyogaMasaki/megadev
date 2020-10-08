.section .text
/* External interrupt */
.global _EXINT
_EXINT:
/* jsr ext_rx */
rte

/* HBLANK interrupt */
.global _HINT
_HINT:
rte

/* VBLANK interrupt */
.global _VINT
_VINT:
jmp vblank_int

