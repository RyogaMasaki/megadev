.text
/* PROGRAM HEADER */
/* More information can be found at https://www.plutiedev.com/rom-header */
  .ascii "SEGA MEGA DRIVE " | Hardware name (16 bytes); The first four bytes MUST be 'SEGA' or TMSS Megadrives will fail
  .ascii "(C)SEGA 1988.OCT" | Copyright holder & release date (16 bytes)
  .ascii "YOUR GAME NAME                                  " | Domestic name of program/game (48 bytes)
  .ascii "YOUR GAME NAME                                  " | Intl name of program/game (48 bytes)
	.ascii "GM XXXXXXXX-XX"	| Version identifier (14 bytes)
	.word	0x0000 | Checksum
	.ascii "J               "	| Supported input devices (16 bytes)
	.long	0x00000000	| Start address of ROM
	.long	0x003FFFFF	| End address of ROM 
	.long	0x00FF0000	| Start address of RAM
	.long	0x00FFFFFF	| End address of RAM
	.ascii	"    " 		| Extra RAM
	.long	0x00000000	| Extra RAM start address
	.long	0x00000000	| Extra RAM end address
	.long	0x00000000	| Modem support 
	.long	0x00000000	| Unused 
	.ascii "                                        "	| Notes (40 bytes)
	.ascii "JUE             "	| Region codes (16 bytes)
.align 2

