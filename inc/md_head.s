
/* MegaDrive program metadata */
/* Modify this as necessary */
__MD_HEAD:
  .ascii "SEGA MEGA DRIVE " /* Hardware name (16 bytes) */
  .ascii "(C)SEGA 1992.SEP" /* Copyright holder & release date (16 bytes) */
  .ascii "YOUR GAME NAME                                  " /* Domestic name of program/game (48 bytes) */
  .ascii "YOUR GAME NAME                                  " /* Intl name of program/game (48 bytes) */
	.ascii "GM XXXXXXXX-XX"	/* Version number (14 bytes) */
	dc.w	0x0000
	.ascii "J               "	/* Supported input devices (16 bytes) */
	dc.l	0x00000000	/* Start address of ROM; no reason to modify this */
	dc.l	_end				/* End address of ROM; do not modify */
	dc.l	0x00FF0000	/* Start address of RAM; do not modify */
	dc.l	0x00FFFFFF	/* End address of RAM */
	dc.l	0x00000000	/* SRAM enabled */
	dc.l	0x00000000	/* Unused */
	dc.l	0x00000000	/* Start address of SRAM */
	dc.l	0x00000000	/* End address of SRAM */
	dc.l	0x00000000	/* Unused */
	dc.l	0x00000000	/* Unused */
	.ascii "                                        "	/* Notes (40 bytes) */
	.ascii "JUE             "	/* Region codes (16 bytes) */
