
.global res_test_chr
.global res_test_pal
.global res_test_map

.global res_border_chr
.global res_border_pal
.global res_border_map

.section .rodata

res_border_chr:
.incbin "res/border.chr"
.align 2

res_border_pal:
.incbin "res/border.pal"
.align 2

res_border_map:
.incbin "res/border.map"
.align 2
