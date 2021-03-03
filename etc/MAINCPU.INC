;-----------------------------------------------------------------------
;       File Name - MAINCPU.INC
;-----------------------------------------------------------------------
;This file contains all equates used by the main cpu programs           ;
;                                                                       ;
;      REVISION HISTORY:                                                ;
;                                                                       ;
;   name     date       comments                                        ;
;   ----    -------     -----------------------------------             ;
;   DRM     03/29/93    file created                                    ;
;   DWM     04/28/93    converted to SNASM debugger                     ;
;-----------------------------------------------------------------------;
;  MAIN CPU MEMORY MAP
;-----------------------------------------------------------------------
;  IP starts at $ff0000 - IP is the initial program start
;  MAINOS starts at $ff1000 - MAINOS is the program loaded by IP
;  STACK starts at $fffd00 - the stack grows down from $fffd00
;                         - the stack is $100 bytes
;  The memory above $fffd00 is filled with the jump table, etc.
;  The memory above $fffd00 is not available for general purpose use
;  Base of 2M bit memory is at $200000 in 2M bit mode
;  Base of 1M bit memory is at $200000 in 1M bit mode
;
;
;-----------------------------------------------------------------------;

  if ~def(MAINCPU_INC)
MAINCPU_INC equ 1
;-----------------------------------------------------------------------;

MAIN_2M_BASE    equ     $200000         ;word RAM base in 2M bit mode
MAIN_1M_BASE    equ     $200000         ;word RAM base in 1M bit mode
IP_START        equ     $ff0000         ;start of IP program
MAINOS_ADDR     equ     $ff1000         ;start of Main OS (Main CPU Prog)
STACK           equ     $fffd00         ;start of STACK (grows down)

;  OS system RAM assignments
;  jump table
;  vector table is 6 bytes each, but an address only needs 4 bytes.
;  Each table entry contains 2 bytes of table data and 4 bytes of 
;  address.  In other code, when you see these vectors accessed, they
;  will always be accessed with a +2, and that is why.

os_sys_ram      equ     $fffd00
_reset          equ     os_sys_ram      ;fffd00 -reset jump table
_mlevel6        equ     _reset+6        ;fffd06 -V interrupt
_mlevel4        equ     _mlevel6+6      ;fffd0c -H interrupt
_mlevel2        equ     _mlevel4+6      ;fffd12 -external interrupt
_mtrap00        equ     _mlevel2+6      ;fffd18 -TRAP #00
_mtrap01        equ     _mtrap00+6      ;fffd1e
_mtrap02        equ     _mtrap01+6      ;fffd24
_mtrap03        equ     _mtrap02+6      ;fffd2a
_mtrap04        equ     _mtrap03+6      ;fffd30
_mtrap05        equ     _mtrap04+6      ;fffd36
_mtrap06        equ     _mtrap05+6      ;fffd3c
_mtrap07        equ     _mtrap06+6      ;fffd42
_mtrap08        equ     _mtrap07+6      ;fffd48
_mtrap09        equ     _mtrap08+6      ;fffd4e
_mtrap10        equ     _mtrap09+6      ;fffd54
_mtrap11        equ     _mtrap10+6      ;fffd5a
_mtrap12        equ     _mtrap11+6      ;fffd60
_mtrap13        equ     _mtrap12+6      ;fffd66
_mtrap14        equ     _mtrap13+6      ;fffd6c
_mtrap15        equ     _mtrap14+6      ;fffd72
_monkerr        equ     _mtrap15+6      ;fffd78 -onk
_madrerr        equ     _monkerr+6      ;fffd7e -address error
_mcoderr        equ     _monkerr+6      ;fffd7e -undefined code
_mdiverr        equ     _mcoderr+6      ;fffd84 -divide error
_mtrperr        equ     _mdiverr+6      ;fffd8e
_mnocod0        equ     _mtrperr+6      ;fffd90
_mnocod1        equ     _mnocod0+6      ;fffd96
_mspverr        equ     _mnocod1+6      ;fffd9c
_mtrace         equ     _mspverr+6      ;fffda2
_vint_ex        equ     _mtrace+6       ;fffda8

;---------------------------------------------------------------------------
; the comment above says the memory area above $FFD000is not for general use.
;  the jump table is considered system use.  Below you will see that we have
;  put our VDP slaves in the "not for general use area".  This came from a
;  code example contained in CD Tech Note #3.  That code used this same area
;  for VDP slaves.  As of 5/25/93, SOJ has not provided an answer as to
;  whether this area is okay to use.  For production games, I would advise not
;  using this area, since the manual says this area is not for general use.
;
; We do know that trying to use any memory after these slaves ($FFFDDD) will
;  cause the machine to lock up and die.
;----------------------------------------------------------------------------

;VDP reg data -- VDP slave values
rg_dat         equ         _vint_ex+6;fffdae -start of VDP reg -  #0 data
VDPSlaves       equ        rg_dat    ;fffdae -copy of contents of all 24 VDP regs
VDP_ModeSet1    equ        rg_dat+$01;fffdaf -register labels are on even bytes
VDP_ModeSet2    equ        rg_dat+$03;fffdb1 -register values are on odd bytes
VDP_PatternA    equ        rg_dat+$05     ;fffdb3
VDP_Window      equ        rg_dat+$07     ;fffdb5
VDP_PatternB    equ        rg_dat+$09     ;fffdb7
VDP_SpriteAttr  equ        rg_dat+$0B     ;fffdb9
VDP_Reg6        equ        rg_dat+$0D     ;fffdbb
VDP_BackCol     equ        rg_dat+$0F     ;fffdbd
VDP_Reg8        equ        rg_dat+$11     ;fffdbf
VDP_Reg9        equ        rg_dat+$13     ;fffdc1
VDP_HIntReg     equ        rg_dat+$15     ;fffdc3
VDP_ModeSet3    equ        rg_dat+$17     ;fffdc5
VDP_ModeSet4    equ        rg_dat+$19     ;fffdc7
VDP_HScroll     equ        rg_dat+$1B     ;fffdc9
VDP_Reg14       equ        rg_dat+$1D     ;fffdcb
VDP_AutoInc     equ        rg_dat+$1F     ;fffdcd
VDP_ScrollSize  equ        rg_dat+$21     ;fffdcf
VDP_WindowHPos  equ        rg_dat+$23     ;fffdd1
VDP_WindowVPos  equ        rg_dat+$25     ;fffdd3
DMASlaves       equ        rg_dat+$26  ;fffdd4 -5 DMA registers are included
VDP_DMALenLo    equ        rg_dat+$27  ;fffdd5 -but shouldn't be copied with
VDP_DMALenHi    equ        rg_dat+$29  ;fffdd7 -other slaves
VDP_DMASrcLo    equ        rg_dat+$2B     ;fffdd9
VDP_DMASrcMid   equ        rg_dat+$2D     ;fffddb
VDP_DMASrcHi    equ        rg_dat+$2F     ;fffddd

;-------------------------------------------------------------------------
;  Mega Drive System I/O Area
;-------------------------------------------------------------------------

Data1           equ     $A10003
Data2           equ     $A10005
Data3           equ     $A10007
Ctrl1           equ     $A10009
Ctrl2           equ     $A1000B
Ctrl3           equ     $A1000D
SCtrl1          equ     $A10013
SCtrl2          equ     $A10019
SCtrl3          equ     $A1001F

Z80Base         equ     $A00000
Z80NoROM        equ     Z80Base+4       ;flag for disabling Z80 ROM accesses
Z80Note         equ     Z80Base+5       ;semitone (0..11)
Z80Octave       equ     Z80Base+6       ;octave (0..7)
Z80Play         equ     Z80Base+7       ;start flag
Z80Stop         equ     Z80Base+8       ;stop flag
IOBase          equ     $A10000
ControlBase     equ     $A11000

SoundRam        equ     $A00000
YM2612          equ     $A04000
Z80Bank         equ     $A06000

VersionNo       equ     $A10001
Z80BusReq       equ     $A11100 ; bit 8 (high=BusReq)
Z80Reset        equ     $A11200 ; bit 8 (low=Reset)


MAIN_GA_BASE    equ     $A12000 ;Main CPU gate array registers base address

;-----------------------------------------------------------------------
; MAIN-CPU GATE ARRAY REGISTER OFFSETS
;-----------------------------------------------------------------------
GA_RESET        EQU   $0000             ; peripheral reset
GA_MEMORYMODE   EQU   $0002             ; memory mode / write protect
GA_CDCMODE      EQU   $0004             ; CDC mode / device destination
GA_HINTVECT     EQU   $0006             ; horizontal interrupt address
GA_CDCHOSTDATA  EQU   $0008             ; 16 bit CDC data to host
GA_STOPWATCH    EQU   $000C             ; CDC/gp timer 30.72us lsb
GA_COMFLAGS     EQU   $000E             ; CPU to CPU commo bit flags
GA_COMCMD       EQU   $0010             ; 8 SUB->MAIN word registers
GA_COMSTAT      EQU   $0020             ; 8 MAIN->SUB word registers
GA_MAIN2SUB     EQU   $0010             ;8 MAIN->SUB word registers
GA_SUB2MAIN     EQU   $0020             ;8 SUB->MAIN word registers

;Note: Using 8 MAIN->SUB word registers (GA_MAIN2SUB) for communicating
;pointer position and button information to SUB CPU
;You may use these word registers for anything you wish.  This was used as
; an example of passing info from the main to the sub cpu.

CUR_X           EQU   $0010             ;cursor X position  (word)
CUR_Y           EQU   $0012             ;cursor Y position  (word)
BUT_A           EQU   $0014             ;button A held info (byte)
BUT_B           EQU   $0015             ;button B held info (byte)
BUT_C           EQU   $0016             ;button C held info (byte)
BUT_START       EQU   $0017             ;button START held info (byte)


;-----------------------------------------------------------------------
; MAIN-CPU RESET REGISTER BIT NUMBERS & MASKS
;-----------------------------------------------------------------------
RESET_SRES_MSK  EQU   $0001             ; Sub-CPU reset
RESET_SBRQ_MSK  EQU   $0002             ; Sub-CPU bus request
RESET_IFL2_MSK  EQU   $0100             ; INT02 to Sub-CPU

RESET_SRES_BIT  EQU   0
RESET_SBRQ_BIT  EQU   1
RESET_IFL2_BIT  EQU   8


;-----------------------------------------------------------------------
; MAIN-CPU MEMORYMODE REGISTER BIT NUMBERS & MASKS
;-----------------------------------------------------------------------
MEMORYMODE_RET_MSK  EQU   $0001
MEMORYMODE_DMNA_MSK EQU   $0002
MEMORYMODE_MODE_MSK EQU   $0004
MEMORYMODE_BK_MSK   EQU   $00C0
MEMORYMODE_WP0_MSK  EQU   $0100
MEMORYMODE_WP1_MSK  EQU   $0200
MEMORYMODE_WP2_MSK  EQU   $0400
MEMORYMODE_WP3_MSK  EQU   $0800
MEMORYMODE_WP4_MSK  EQU   $1000
MEMORYMODE_WP5_MSK  EQU   $2000
MEMORYMODE_WP6_MSK  EQU   $4000
MEMORYMODE_WP7_MSK  EQU   $8000

MEMORYMODE_RET_BIT  EQU   0
MEMORYMODE_DMNA_BIT EQU   1
MEMORYMODE_MODE_BIT EQU   2
MEMORYMODE_WP0_BIT  EQU   8
MEMORYMODE_WP1_BIT  EQU   9
MEMORYMODE_WP2_BIT  EQU   10
MEMORYMODE_WP3_BIT  EQU   11
MEMORYMODE_WP4_BIT  EQU   12
MEMORYMODE_WP5_BIT  EQU   13
MEMORYMODE_WP6_BIT  EQU   14
MEMORYMODE_WP7_BIT  EQU   15


;-----------------------------------------------------------------------
; MAIN-CPU COMFLAG BIT NUMBERS & MASKS
;-----------------------------------------------------------------------
COMFLAGS_SUBBUSY_MSK      EQU $0001
COMFLAGS_SUBACK_MSK       EQU $0002
COMFLAGS_SUBRAMREQ_MSK    EQU $0004
COMFLAGS_SUBSYNC_MSK      EQU $0008
COMFLAGS_MAINBUSY_MSK     EQU $0001
COMFLAGS_MAINACK_MSK      EQU $0002
COMFLAGS_MAINRAMREQ_MSK   EQU $0004
COMFLAGS_MAINSYNC_MSK     EQU $0008

COMFLAGS_SUBBUSY_BIT      EQU 0
COMFLAGS_SUBACK_BIT       EQU 1
COMFLAGS_SUBRAMREQ_BIT    EQU 2
COMFLAGS_SUBSYNC_BIT      EQU 3

COMFLAGS_SUBSERVR_BIT			EQU 4     ;added by dwm 5/11/93

COMFLAGS_MAINBUSY_BIT     EQU 8
COMFLAGS_MAINACK_BIT      EQU 9
COMFLAGS_MAINRAMREQ_BIT   EQU 10
COMFLAGS_MAINSYNC_BIT     EQU 11

COMFLAGS_MAINSERVR_BIT    EQU 12   ;added by dwm 5/11/93


;---------------------------------------------------------------
;
; sub/main cpu communications register equates
;
;---------------------------------------------------------------
MAIN_ACK_BIT              EQU $FF
SUB_ACK_BIT               EQU $EE
COMM_CLEAR_BIT            EQU $00

;---------------------------------------------------------------
;  Video Display Processor - VDP
;---------------------------------------------------------------
VDPData         equ     $C00000
VDPControl      equ     $C00004
VDPStatus       equ     $C00004
VDPHVCount      equ     $C00008

;bit patterns for doing video things
IE0             equ     %0000000000100000
IE1             equ     %0000000000010000
IE2             equ     %0000000000001000
M1              equ     %0000000000010000
M2              equ     %0000000000001000
M3              equ     %0000000000000010
DISP            equ     %0000000001000000
VSCR            equ     %0000000000000100
HSCR            equ     %0000000000000010
LSCR            equ     %0000000000000001
RS0             equ     %0000000010000000
RS1             equ     %0000000000000001
STE             equ     %0000000000001000
LSM1            equ     %0000000000000100
LSM0            equ     %0000000000000010
VSZ1            equ     %0000000000100000
VSZ0            equ     %0000000000010000
HSZ1            equ     %0000000000000010
HSZ0            equ     %0000000000000001
DMD1            equ     %0000000010000000
DMD0            equ     %0000000001000000
CD0             equ     %0100000000000000
CD1             equ     %1000000000000000
CD2             equ     %0000000000010000
CD3             equ     %0000000000100000
CD4             equ     %0000000001000000
CD5             equ     %0000000010000000
DMA             equ     %0000000000000010


;-----------------------------------------------------------------------
  endif

;-----------------------------------------------------------------------
;       File Name - MAINCPU.INC
;       End of file
;-----------------------------------------------------------------------
