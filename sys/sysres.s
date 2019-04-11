sysfont:
  .incbin "../res/sysfont.mdchr"
	.equ sysfontlen, .-sysfont

syspal:
	.incbin "../res/sysfont.mdpal"
	.equ syspallen, .-syspal
