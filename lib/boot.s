/**
 * \file boot.s
 * \brief Mega CD boot sector (header and IP/SP)
 */

#include "project.h"

DiscHeader:
DiscType: .ascii "SEGADISCSYSTEM  "		/*Disc Type (must be one of the allowed values)*/

VolumeName: .asciz cfg_vol_id   /*Volume ID, 11 bytes + 0 terminator*/
VolumeSystem:	.word 0x100, 0x1				/*System ID, Type*/
SystemName:	.asciz "SEGASYSTEM "			/*System Name*/
SystemVersion:	.word 0,0							/*System Version, Type*/

# The US/EU security bins are much larger
# so we need to correct for this (as outlined in the Mega CD
# technial bulletins)
#IP_Addr:	.long IPStart-DiscHeader		/*IP Start Address*/
#IP_Size:	.long IPEnd-IPStart					/*IP End Address*/

IP_Addr:	.long 0x800		/*IP Start Address*/
IP_Size:	.long 0x800					/*IP End Address*/
IP_Entry:	.long 0
IP_WorkRAM:	.long 0
SP_Addr:	.long SPStart-DiscHeader		/*SP location on disc (usually sector #2, 0x1000)*/
SP_Size:	.long SPEnd-SPStart					/*SP End Address */
SP_Entry:	.long 0
SP_WorkRAM:	.long 0
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
		
# =======================================================================================
#  Game Header
# =======================================================================================	
HardwareType:	.ascii "SEGA MEGA DRIVE "
Copyright:	  .ascii "(C)     2020.OCT"
NativeName:	  .ascii cfg_name_jp
OverseasName:	.ascii cfg_name_intl
DiscID:		.ascii "GM 00-0000-00   "
IO:		.ascii "J               "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
Region:		.ascii cfg_region

// if all the above text is correct, we should be at 0x200
.org 0x200

/*
	We need to compile ip and sp seperately since they need their own
	memory map (ip runs from Work RAM, sp from PRG RAM)
*/
IPStart:
  .incbin "ip.bin"
IPEnd:

.org	0x1000
SPStart:
  .incbin "sp.bin"
SPEnd:

.align	0x8000
