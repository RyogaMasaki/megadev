.text
/* PROGRAM HEADER */
/* More information can be found at https://www.plutiedev.com/rom-header */
  .ascii "SEGA MEGA DRIVE " | Hardware name (16 bytes); The first four bytes MUST be 'SEGA' or TMSS Megadrives will fail
  .ascii "(C)SEGA 1988.OCT" | Copyright holder & release date (16 bytes)
  .ascii "YOUR GAME NAME                                  " | Domestic name of program/game (48 bytes)
  .ascii "YOUR GAME NAME                                  " | Intl name of program/game (48 bytes)
	.ascii "GM XXXXXXXX-XX"	| Version identifier (14 bytes)
	dc.w	0x0000 | Checksum
	.ascii "J               "	| Supported input devices (16 bytes)
	dc.l	0x00000000	| Start address of ROM
	dc.l	0x003FFFFF	| End address of ROM 
	dc.l	0x00FF0000	| Start address of RAM
	dc.l	0x00FFFFFF	| End address of RAM
	.ascii	"    " 		| Extra RAM
	dc.l	0x00000000	| Extra RAM start address
	dc.l	0x00000000	| Extra RAM end address
	dc.l	0x00000000	| Modem support 
	dc.l	0x00000000	| Unused 
	.ascii "                                        "	| Notes (40 bytes)
	.ascii "JUE             "	| Region codes (16 bytes)
.align 2

