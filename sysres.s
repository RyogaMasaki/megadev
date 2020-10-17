.section .rodata

.global sysfont_chr
sysfont_chr:
  .incbin "sysfont.chr"
  .align 2

.global sysfont_pal
sysfont_pal:
  .incbin "sysfont.pal"
  .align 2

