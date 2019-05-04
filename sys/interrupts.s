.text
/* External interrupt */
_EXINT:
/* jsr ext_rx */
rte

/* HBLANK interrupt */
_HINT:
rte

/* VBLANK interrupt */
_VINT:
jmp vblank_int

