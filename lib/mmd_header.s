.section .text
/*
	The MMD file data is now located at the start of Word RAM. An MMD
	is essentially a self contained Megadrive/CD program. It has a 0x100
	size header followed by the actual code/data. This header is mostly 
	empty, though the first 0x14 bytes contain information about where
	the data should be placed and how it should be executed. Here is an
	explanation of the header:

	Offset | Size | Description
	0 | word | If Bit 6 is set, Word RAM is given to Sub CPU
	2 | long | MMD Data section destination
	6 | word | Size of Data section
	8 | long | Code entry point
0xC | long | HINT vector
0x10| long | VINT vector

	(It is unknown if the word value at offset 0 has any other functionality
	and needs a bit more research.)
*/

.word 0
.long MMD_DEST
.word MMD_TEXT_SZ
.long main
.long _HINT
.long _VINT

.align	0x100
