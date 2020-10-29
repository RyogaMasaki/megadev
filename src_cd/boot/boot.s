# =======================================================================================
#  Sega CD Header (Based on Sonic CD"s header)
# =======================================================================================
DiscHeader:
DiscType:	.ascii "SEGADISCSYSTEM  "		/*Disc Type (must be one of the allowed values)*/
VolumeName:	.asciz "MMD_LOAD   "			/*Disc ID*/
VolumeSystem:	.word 0x100, 0x1				/*System ID, Type*/
SystemName:	.asciz "SEGASYSTEM "			/*System Name*/
SystemVersion:	.word 0,0							/*System Version, Type*/

# The US/EU security bins are much larger than the original JP bin
# so we need to correct for this (as outlined in the Mega CD
# technial bulletins)
#IP_Addr:	.long IPStart-DiscHeader		/*IP Start Address*/
#IP_Size:	.long IPEnd-IPStart					/*IP End Address*/

IP_Addr:	.long 0x800		/*IP Start Address*/
IP_Size:	.long 0x800		/*IP End Address*/
IP_Entry:	.long 0
IP_WorkRAM:	.long 0
SP_Addr:	.long SPStart-DiscHeader		/*SP Start Address (usually sector #2, 0x1000)*/
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
Copyright:	.ascii "(C)     2020.JAN"
NativeName:	.ascii "MMD LOADER                                      "
OverseasName:	.ascii "MMD LOADER                                      "
DiscID:		.ascii "GM 00-0000-00   "
IO:		.ascii "J               "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
Region:		.ascii "JUE             "

IPStart:
		.incbin "src_cd/boot/ip.bin"
IPEnd:

.org	0x1000
SPStart:
		.incbin	"src_cd/boot/sp.bin"
SPEnd:

.align	0x8000
