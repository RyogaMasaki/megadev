/*
-----------------------------------------------------------------------
 ip.s
 Initial Program (Main CPU)
-----------------------------------------------------------------------
 This code is stored in the disc boot sector and is thus quite small.
 After passing the security check, it will issue a command to the Sub
 CPU to load an extended program to run on the Main CPU.
*/

.include	"maincpu.s"
.include 	"maincpu_macros.s"

# address where the small mmd load request code will run from
.equ			mmd_loader_ptr,	0xff1000

/*Code runs from Main CPU Work RAM (0xFF0000)*/
.text

/*
	Security code per region
	Be sure to comment/uncomment to match the region of the hardware that
	you plan to run this on.
*/
.incbin			"sec_jp.bin"
#.incbin		"sec_eu.bin"
#.incbin		"sec_us.bin"

	# dropped here after the security code
IP_INIT:
	# send INT2 to sub on VINT
	/*entries in the jump table are 68k code, with a JSR followed by the
	address. therefore, to change an address, we need to account for the
	JSR which is 2 bytes, and add that to the jump table entry offset*/
	move.l	#trigger_int2, (_mlevel6 + 2)		
	# TODO: is this necessary? is this not the hint vector default anyway?
	move.w	0xFD0C, (GA_HINTVECT)
	move.l	#null_int, (_mlevel4 + 2)
	GRANT_2M
	CLEAR_COMM_REGS
	/*The Sonic CD code moves the useful part of the IP code out farther
	into the Work RAM so that this earlier section (starting at 0xff0000)
	is clear for IPX, which is the actual Main side application code.
	We're not going to load a Main application, but we'll keep the code
	to move our "useful" code further out in case we want to implement a
	larger project with a larger Main application in this style.*/
	lea			main_ap, a0				/*ptr to code to move*/
	lea			mmd_loader_ptr, a1	/*ptr to new code destination*/
	move.w	#_end-main_ap-1, d7	/*size of the chunk*/
1:move.b	(a0)+, (a1)+					/*move it*/
	dbf			d7, 1b
	moveq		#1, d0
	jsr			send_sub_cmd				/* end cmd 1 to Sub CPU*/
	jmp			mmd_loader_ptr		/*and jump to it*/


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


/*
	This is our "main application." In a full sized project, this is where
	the overall flow of the program would be controlled - from loading
	the title screen, then a menu, then a level, then a game over and
	back to title screen, etc.
	In our case, we're just going to send a couple of commands to the Sub
	CPU - load an MMD and execute it, and play an audio track.
*/
main_ap:
	# send cmd 1 - load MMD file	
	movea.l	MAIN_2M_BASE+8, a0	/*get MMD entry point*/
	move.l	MAIN_2M_BASE+2, d0	/*get MMD data destination*/
	beq			1f				/*if no destination, skip the copy*/
	movea.l	d0, a2		/*put destination in a2*/
	lea			MAIN_2M_BASE+0x100, a1	/*start of MMD Data section in a1*/
	move.w	MAIN_2M_BASE+6, d7		/*size of MMD Data in d7*/
0:move.l	(a1)+, (a2)+			/*copy MMD Data to destination*/
	dbf			d7, 0b
1:move.l	MAIN_2M_BASE+0xc, d0	/*set HINT vector if provided*/
	beq			2f
	move.l	d0, _mlevel4+2
	move.l  MAIN_2M_BASE+0x10, d0
	beq     2f
	move.l  d0, _mlevel6+2
2:
	# send cmd 2 - play audio track
	moveq		#2, d0
	jsr			send_sub_cmd
	# jump to the MMD code entry point
	jmp			(a0)

send_sub_cmd:
	move.w	d0, GA_COMCMD0	/*send the command to command register #0*/
0:tst.w		GA_COMSTAT0			/*wait for response on status register #0*/
	beq			0b
	move.w	#0, GA_COMCMD0	/*send no command*/
1:tst.w		GA_COMSTAT0			/*wait for response*/
	bne			1b
	rts

trigger_int2:
	bset		#RESET_IFL2_BIT-8, (GA_RESET)	/*trigger INT2 on Sub CPU*/
null_int:
	rte
_ip_end:
_end:
