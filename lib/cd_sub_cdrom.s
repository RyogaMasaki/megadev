/**
 * \file cd_sub_cdrom.s
 * CD-ROM File Access API
 * Subdirectories are *not* supported. All files should be in the root.
 */

#ifndef MEGADEV__CD_SUB_CDROM_S
#define MEGADEV__CD_SUB_CDROM_S

#include "macros.s"
#include "cd_sub_cdrom_def.h"
#include "cd_sub_bios_macros.s"

.section .text

/*
  Compare strings at a1 and a2
  IN:
    a1 - ptr to string 1
    a2 - ptr to string 2
    d1 - length
*/
.altmacro
.macro COMPARE_STRING
.local LOOP
.local END

  PUSHM    d1/a1-a2
LOOP:
  cmpm.b  (a1)+, (a2)+
  bne      END
  dbf      d1, LOOP
  moveq    #0, d1
END:
  POPM    d1/a1-a2  // movem doesn't not affect registers; Z will be preserved
.endm


/*
  Convenience sub to get a file loaded
   IN:
  a0 - Pointer to filename string (zero terminated)
  a1 - Pointer to destination data buffer
*/
load_file_sub:
  move.w  #ACC_OP_LOAD_SUB, access_op
  move.l  a0, filename_ptr
  move.l  a1, file_dest_ptr
0:jbsr    _WAITVSYNC
  jbsr get_acc_op_result
  bcs      0b              /*wait for completion*/
  cmpi.w  #RESULT_OK, d0  /*check status*/
  bne      load_file_sub        /*try again if bad status*/
  rts

/**
 * Convenience macro to wait for an access operation to finish
 * OUT:
*   d0 - result code
 * BREAK: d1
 */
.altmacro
.macro WAIT_FOR_ACC_OP
LOCAL loop

loop:
  jsr			 _WAITVSYNC
	jbsr     get_acc_op_result
	bcs			 loop
.endm

/**
 * MUST be called every VINT in order to keep the access loop going
 * BREAK: a0
 */
.macro PROCESS_ACC_LOOP
  movea.l  acc_loop_breakpt, a0  /*load the jump ptr*/
  jmp      (a0)                    /*and pick up where we left off*/
.endm

/**
 * Kickstarts the load process by setting initial mode
 * This should be called in sp_init before VINT has been enabled
 */
.macro INIT_ACC_LOOP
  move.l  #access_op_idle, acc_loop_breakpt
  move.w  #ACC_OP_IDLE, access_op
.endm

/**
 * Get a pointer to the cached file info entry
 * 
 * IN:
 *  a0 - ptr to file name
 * OUT:
 *  CS - File not found
 *  CC - File found
 *  a0 - (if found) ptr to file list entry
 * BREAK: d0-d1/a1-a2
 */
get_file_info:
  // part 1 - get filename length
  // we need this for string comparison
  moveq    #0, d1     // d1 will hold the size
  movea.l  a0, a1     // a1 is the string work register
  moveq    #0xa, d0   // max length of filename (without version info)
0:tst.b    (a1)       // begin check for end of string
  beq      1f         // Hit \0 - end of filename string
  cmpi.b   #';', (a1)  // Hit ; - end of filename string
  beq      1f
  cmp.b    #' ', (a1)  // Hit space - end of filename string (or invalid)
  beq      1f
  addq.w   #1, d1       // increment size
  addq.l   #1, a1       // increment char pointer
  dbf      d0, 0b

  // part 2 - find the filename in the directory cache
1:move.w   dir_entry_count, d0  // for each file in the dir
  subq.w   #1, d0          // -1 for loop index
  movea.l  a0, a1          // point string work reg to filename
  lea      dir_cache, a2   // directory cache in a2
2:COMPARE_STRING           // compare the filename to this dir entry
  beq      3f              // found the file!
  adda.w   #0x20, a2       // not found, move to next entry
  dbf      d0, 2b

  move     #1, ccr     // couldn't find the file! report file not found
  rts

3:movea.l  a2, a0      // set a0 to ptr to the directory entry
  move     #0, ccr     // report file found
  rts


/**
 * Check if an access operation is still in process
 * If it has completed, returns the last result code
 * IN:
 *  none
 * OUT:
 *  CS - Access op in progress
 *  CC - Access op complete (access loop is idle)
 *  If op complete:
 *  d0 - Result code
 *  d1 - If result is OK: contains size of file in bytes
 *       If result is file load fail: number of sectors read
 */
get_acc_op_result:
  cmpi.w   #ACC_OP_IDLE, access_op    //if status is anything but idle*/
  bne      2f                         // then jump down*/
  move.w   access_op_result, d0
  cmpi.w   #RESULT_OK, d0            /*check for good status*/
  bne      0f                        /*not good, jump down*/
  move.l   cdrom_record_size, d1      /*status ok, get size of the last read record*/
  bra      1f
0:cmpi.w   #ACCRES_LOAD_FILE_ERR, d0    /*check for load file subroutine failure*/
  bne      1f
  move.w   sectors_read_count, d1      /*if so, return number of sectors read*/
1:move     #0, ccr        /*access loop completed*/
  rts
2:move     #1, ccr              /*access loop is busy*/
  rts

/**
 * CD-ROM access operation switch
 * The operation should be requested by setting the access_op value rather
 * than calling any of these functions on their own.
 */
access_op_idle:
  jbsr      accloop_break
op_switch:
  move.w   access_op, d0
  add.w    d0, d0
  move.w   op_jmptbl(pc,d0.w), d0
  jbra     op_jmptbl(pc,d0.w)
  rts

op_jmptbl:
  .word    access_op_idle - op_jmptbl
  .word    access_op_load_dir - op_jmptbl
  .word    access_op_load_dma_word - op_jmptbl
  .word    access_op_load_sub - op_jmptbl
  .word    access_op_load_dma_prg - op_jmptbl
  .word    access_op_load_dma_pcm - op_jmptbl

/**
 * Load a file to Word RAM via DMA
 */ 
access_op_load_dma_word:
  move.b   #CDC_WRAMDMA, cdc_dev_dest
  move.l   #load_data_dma, (load_method_ptr)
  jbra     load_process

/**
 * Load a file to a Sub CPU address space
 */
access_op_load_sub:
  move.b   #CDC_SUBREAD, cdc_dev_dest
  move.l   #load_data_sub, (load_method_ptr)
  jbra     load_process

/**
 * Load a file to PRG RAM via DMA
 */
access_op_load_dma_prg:
  move.b   #CDC_WRAMDMA, cdc_dev_dest
  move.l   #load_data_dma, (load_method_ptr)
  jbra     load_process

/**
 * Load a file to PCM Wave Data memory via DMA
 */
access_op_load_dma_pcm:
  move.b   #CDC_PCMDMA, cdc_dev_dest
  move.l   #load_data_dma, (load_method_ptr)

/**
 * Shared code for the file load operations
 */
load_process:
  movea.l  (filename_ptr), a0
  jbsr     get_file_info       // get file info from dir cache
  bcs      load_proc_notfound  // jump down if file not found
  move.l   0x18(a0), cdread_sector_start  // get start sector
  move.l   0x1c(a0), d1                   // get file size (bytes)
  move.l   d1, cdrom_record_size
  /*get the file size in sectors by 'dividing' by 2048*/
  /*TODO: access_op_load_dir actually uses divu... use that here too?*/
  // or can't we just shift right 11 bits...?
  move.l   #1, cdread_sector_count   // file must be at least 1 sector
0:subi.l   #0x800, d1                // subtract 2K bytes (1 sector)
  ble      1f                        // we've hit the end of the file
  addq.l   #1, cdread_sector_count   // add 1 to the sector count
  bra      0b
test_label:
1:movea.l  load_method_ptr, a0
  jbsr     (a0)                      // actually load some data
3:move.w   #ACC_OP_IDLE, access_op   // set the acc loop back to idle
  bra      access_op_idle            // and jump back into the loop
load_proc_notfound:
  /* we set the not found result here as opposed to the get_file_info subroutine
   * so we don't tamper with the load process results, in case get_file_info is
   * called elsewhere
  */
  move.w   #RESULT_NOT_FOUND, access_op_result
  bra      3b

/**
 * Load and cache the root directory entries (filename, offset, size)
 */
access_op_load_dir:
  move.b  #3, cdc_dev_dest            // set CDC data destination

  // part 1 - load primary volume descriptor
  move.l   #0x10, cdread_sector_start  // primary VD is at sector 0x10
  move.l   #1, cdread_sector_count     // read one frame (sector)
  lea      sector_buffer, a0           // temporary data buffer in a0
  move.l   a0, file_dest_ptr         // make it the data destination
  bsr      load_data_sub               // actually get data
  cmpi.w   #RESULT_LOAD_FAIL, access_op_result  // check for problems
  beq      cdacc_loop_loaddir_err      // read failed, jump down
  lea      sector_buffer, a1           // PVD is in the buffer now
  move.l   0xa2(a1), cdread_sector_start  // start sector of root dir record
  move.l   0xaa(a1), d0                   // size of root dir record (bytes)
  divu.w   #0x800, d0          // get size in sectors
  swap     d0                  // check for modulus
  tst.w    d0
  beq      0f
  addi.l   #0x10000, d0        // if there's a remainder, add a sector
                               // (value is swapped right now; upper word
                               // is sector count)
0:swap     d0                  // back to normal order
  move.w   d0, record_size

  // part 2 - loop over root dir sectors and build directory cache
  clr      dir_entry_count
1:move.l   #1, cdread_sector_count  // read one sector
  lea      sector_buffer, a1
  move.l   a1, file_dest_ptr      // setup destination
  bsr      load_data_sub            // actually get data
  cmpi     #RESULT_LOAD_FAIL, access_op_result  // any issues?
  beq      cdacc_loop_loaddir_err   // if so, jump down
  lea      dir_cache, a0    
  move.w   dir_entry_count, d0      // this will be 0 on the sector
  mulu.w   #0x20, d0                // each file entry is 0x20 bytes
  # TODO:  shift left by 5 instead of mulu?
  adda.l   d0, a0    /*move up to the latest file entry offset*/
  lea      sector_buffer, a1
  moveq    #0, d0
2:move.b   0(a1), d0  // no more entries? (size is 0)
  beq      7f         // no more, jump down
  move.b   0x19(a1), 0x17(a0)   //file flags*/
  move.l   6(a1), 0x18(a0)      //file start sector
  move.l   0xe(a1), 0x1c(a0)    //file size in bytes
  moveq    #0, d1               // d1 will be filename char index
4:move.b   0x21(a1,d1.w), (a0,d1.w)  // filename
  addq.w   #1, d1
  cmp.b    0x20(a1), d1  // length of filename (including version suffix)
  blt      4b            // not done with filename yet
5:cmpi.b   #0xc, d1      /// is filename less than 0xC characters in length?
  bge      6f            // no, jump down
  move.b   #' ', (a0, d1.w)    // yes, fill with spaces until it's 0xC length
  addq.w   #1, d1
  bra      5b
6:addq.w   #1, dir_entry_count  //this file entry is done, add it to the count
  adda.l   d0, a1      //move to next entry in dir record
                       // (d0 holds dir record length)
  adda.l   #0x20, a0   // move to next entry in the file list
  bra      2b          // and do it all again
7:subq.w   #1, record_size  // any more sectors left in the dir record?
  bne      1b          // yes, jump back and do it all again
  move.w   #RESULT_OK, access_op_result  // we're good here
load_file_list_end:
  move.w   #ACC_OP_IDLE, access_op  // free and return to access loop
  bra      access_op_idle
cdacc_loop_loaddir_err:
  move.w   #RESULT_DIR_FAIL, access_op_result  // indicate bad result
  bra      load_file_list_end


/**
 * Load data using CDCTRN (only available for Sub CPU Read)
 */
load_data_sub:
  // we want to save the call site in order to properly return, since we'll
  // be messing with the stack by calling accloop_break
  POP       return_ptr
  move.w    #0, sectors_read_count
  move.w    #0x1e, read_retry_count

load_data_begin:
  move.b   cdc_dev_dest, (GA_CDCMODE)
  lea      cdread_sector_start, a0 // point to sector struct for ROMREADN

  /*
    Next we want to partially convert the start sector to MM:SS:FF format and
    get the frame value in particular. This will be used for error checking by
    confirming that the CDC has read the frame (i.e. the sector) we were
    expecting.
  */
  move.l   (a0), d0  // retrieve the start sector
  divu     #75, d0   // get the number of seconds (75 frames / second)
  swap     d0        // put the modulus in the lower half
  HEX2BCD            // convert the value to BCD (because the CDC returns the
                     // value MM:SS:FF format)
  move.b   d0, cdc_frame_check  // cache for later error checking

  BIOS_CDCSTOP     // stop any current CDC transfers
  BIOS_ROMREADN    // begin the data read

  move.w  #0x258, read_timeout
1:bsr      accloop_break  /*take a break here and come back next VINT*/
2:BIOS_CDCSTAT            /*check CDC status since our read call*/
  bcc      3f              /*we have a sector read to be read*/
  subq.w  #1, read_timeout  /*count down read timeout & try again*/
  bge      1b
  subq.w  #1, read_retry_count  /*count down read retry & try again*/
  bge      load_data_begin
  bra      load_data_failure          /*failed completely, jump down*/

3:BIOS_CDCREAD    /*read out the data from the CDC*/
  bcs      4f      /*sector not ready, this shouldn't happen since*/
                  /*CDCSTAT said we were good; jump down & try again*/
  move.l  d0, cdc_read_timecode  /*the timecode for the read sector comes back in d0*/
  move.b  cdc_frame_check, d0    /*bring back the frame count we calculated earlier*/
  cmp.b    cdc_read_timecode+2, d0  /*and check it against the frame count from CDC*/
  beq      5f                      /*things looks good, let's keep going*/
4:subq.w  #1, read_retry_count  /*count down read retry & try again*/
  bge      load_data_begin
  bra      load_data_failure
5:move.w  #0x7ff, d0        /*wait for Data Set Ready flag from CDC*/
  btst    #CDCMODE_DSR_BIT-8, (GA_CDCMODE).l
  dbne    d0, 5b
  bne      6f
  subq.w  #1, read_retry_count  /*no response from CDC in time, retry*/
  bge      load_data_begin
  bra      load_data_failure
6:cmpi.b  #2, cdc_dev_dest  /*is this a main CPU read?*/
  beq      load_data_maincpudest    /*if so, jump down; main cpu can't use CDCTRN*/
  movea.l  (file_dest_ptr), a0  /*setup CDCTRN pointers*/
  lea      cdc_read_timecode, a1
  BIOS_CDCTRN            /*transfer data from CDC to RAM*/
  bcs      7f
  move.b  cdc_frame_check, d0      /*check against our expected frame count again*/
  cmp.b    cdc_read_timecode+2, d0  
  beq      8f                    /*frame count is good, move on*/
7:subq.w  #1, read_retry_count  /*frame count didn't match, retry*/
  bge      load_data_begin
  bra      load_data_failure
  /*why set ccr here? Calling code expected a status value in RAM, not condition code.
  Probably leftover from example code...?*/
8:move    #0, ccr
  moveq    #1, d1    /*prepare to move to next frame*/
  abcd    d1, d0    /*d0 has cdc_frame_check (as BCD), add one to it*/
  move.b  d0, cdc_frame_check      /*TODO: check if this can be re-arranged*/
  cmpi.b  #0x75, cdc_frame_check  /* check if we're past 75 frames (0 indexed,BCD)*/
  bcs      9f        /*not yet*/
  move.b  #0, cdc_frame_check    /*frame counter rolled past 75, reset our check*/
9:BIOS_CDCACK        /*send ack to CDC*/
  move.w  #6, read_timeout    /*reset error counters*/
  move.w  #0x1e, read_retry_count
  addi.l  #0x800, file_dest_ptr  /*move the dest buffer up a sector*/
  addq.w  #1, sectors_read_count    /*add to the sectors read count*/
  addq.l  #1, cdread_sector_start  /*move to the next frame*/
  subq.l  #1, cdread_sector_count  /*countdown frames to be read*/
  bgt      2b          /*and loop back if there are still frames pending*/
  move.w  #RESULT_OK, access_op_result  /*indicate we completed successfully*/
load_data_end:
  move.b  cdc_dev_dest, GA_CDCMODE
  movea.l  return_ptr, a0  /*return to the original call site*/
  jmp      (a0)
load_data_failure:
  move.w  #RESULT_LOAD_FAIL, access_op_result
  bra      load_data_end
  # not entirely certain how this works with Main CPU being the destination,
  # since I'm not 100% clear on the effect of CDC mode
  # in any case, our tutorial doesn't use it
load_data_maincpudest:
  move.w  #6, read_timeout
1:bsr      accloop_break
  btst    #7, GA_CDCMODE  /*check EDT*/
  bne      9b
  subq.w  #1, read_timeout
  bge      1b
  bra      load_data_failure



/**
 * Load data without CDCTRN (for DMA processes)
 */
load_data_dma:
  // we want to save the call site in order to properly return, since we'll
  // be messing with the stack by calling accloop_break
  POP       return_ptr
  move.w    #0, sectors_read_count
  move.w    #0x1e, read_retry_count

load_data_dma_begin:
  move.b   cdc_dev_dest, (GA_CDCMODE)
  lea      cdread_sector_start, a0  // point to sector struct for ROMREADN

  /*
    Next we want to partially convert the start sector to MM:SS:FF format and
    get the frame value in particular. This will be used for error checking by
    confirming that the CDC has read the frame (i.e. the sector) we were
    expecting.
  */
  move.l   (a0), d0  // retrieve the start sector
  divu     #75, d0   // get the number of seconds (75 frames / second)
  swap     d0        // put the modulus in the lower half
  HEX2BCD            // convert the value to BCD (because the CDC returns the
                     // value MM:SS:FF format)
  move.b   d0, cdc_frame_check  // cache for later error checking

  BIOS_CDCSTOP     // stop any current CDC transfers
  BIOS_ROMREADN    // begin the data read

  move.w   #0x258, read_timeout // set up for reading
1:bsr      accloop_break    // take a break here and come back next VINT
2:BIOS_CDCSTAT               // check on the CDC on the status of our data
  bcc      3f                // sector is ready! jump down
  subq.w   #1, read_timeout  // not ready yet,count down read timeout
  bge      1b                // and try again
  subq.w   #1, read_retry_count  // decrement read retry
  bge      load_data_dma_begin   // and try again
  bra      load_data_dma_failure // failed after all attempts, return error

3:BIOS_CDCREAD     // read out the data from the CDC to the destination
  bcs      4f      // data not ready, this really shouldn't happen since
                   // CDCSTAT said we were good; jump down & try again
  lsr      #8, d0  // the timecode for the loaded sector comes back in d0
                   // shift it over to get the frame offset into the low byte
  move.b   cdc_frame_check, d1   // bring back the expected frame offset...
  cmp.b    d1, d0                // and compare the two to make sure they match
  beq      6f                    // all good, let's keep going
4:subq.w   #1, read_retry_count  // didn't match, decrement read retry...
  bge      load_data_dma_begin   // and try again
  bra      load_data_dma_failure // failed after all attempts, return error

6:move.w   #6, read_timeout  // next we want the signal from the CDC that 
                             // everything is done
7:bsr       accloop_break   // give it some time...
  btst     #CDCMODE_EDT_BIT-8, GA_CDCMODE  // check that the EDT bit is set
  beq       0f               // not set yet, retry
  move.b   (cdc_frame_check), d0  // CDC is done, let's prepare for next frame
  moveq    #1, d1                 // grab the error check value
  abcd     d1, d0                 // and BCD add 1 to it, because we are going
                                  // to expect the next frame (sector)
  cmp.b    #0x76, d0                // have we exceeded the 75th frame?
  bne      8f                     // no, jump down
  moveq    #0, d0                 // yes, reset expected frame to 0
8:move.b   d0, (cdc_frame_check)  // cache our expected frame
  bra      9f                     // and keep it moving!

0:subq.w   #1, read_timeout
  bge      7b
  bra      load_data_dma_failure

9:BIOS_CDCACK          // send ack to CDC (required after every sector/frame)
  move.w   #6, read_timeout          // reset error counters for next sector
  move.w   #0x1e, read_retry_count
  addq.w   #1, sectors_read_count    // add to the sectors loaded count
  subq.l   #1, cdread_sector_count   // decrement remaining sector count
  bgt       2b                 // loop back if there are still frames pending
  move.w   #RESULT_OK, access_op_result  // all data loaded!
load_data_dma_return:
  move.b  cdc_dev_dest, GA_CDCMODE // write the dest. again to reset DMA
  movea.l  return_ptr, a0          // return to the original call site
  jmp      (a0)
load_data_dma_failure:
  move.w   #RESULT_LOAD_FAIL, access_op_result
  bra      load_data_dma_return

/*
  Pops the last address from the stack and stores
  in the INT2 call ptr
  Should be called as subroutine rather than directly
*/
accloop_break:
  POP      acc_loop_breakpt
  rts

.section .bss

/**
 * Points to the last location in the access loop
 */
acc_loop_breakpt: .long 0

load_method_ptr: .long 0

# the two longs are the table used by ROMREADN/ROMREADE, so
# it is necessary that there are two consecutive long values!
cdread_sector_start: .long 0
cdread_sector_count: .long 0

.global filename_ptr
filename_ptr: .long 0

.global file_dest_ptr
file_dest_ptr: .long 0

cdrom_record_size: .long 0

.global access_op
access_op: .word 0

access_op_result: .word 0



.align 2

sectors_read_count: .word  0

/**
 * The loop count for checking on whether data is ready from CDC.
 */
read_timeout: .word 0

/**
 * The number of attempts to read a file if a read timeout occurs
 */
read_retry_count: .word 0

cdc_read_timecode: .long  0
cdc_frame_check: .byte  0

.align 2
return_ptr: .long 0

/**
 * CDC Device Destination
 * Specifies the bus the CDC should use for data output
 * Set on the CDC Mode GA register
 */
cdc_dev_dest: .byte 0
.align 2

dir_entry_count:
  .word 0

record_size:    /* in sectors*/
  .word 0

/**
 * Cache for the file info entries
 * 0x20 bytes per entry * 128 files = 4K buffer
 * This can be adjusted as necessary
 */
dir_cache: .space 0x1000

/**
 * Buffer for a single sector of data during disc read work
 */
sector_buffer: .space 0x800

#endif
