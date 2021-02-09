/**
 * \file cd_sub_cdrom_def.h
 * CD-ROM File Access Wrapper Definitions
 */

#ifndef MEGADEV__CD_SUB_CDROM_DEF_H
#define MEGADEV__CD_SUB_CDROM_DEF_H

/*
-----------------------------------------------------------------------
 CD-ROM Access Result
 The values here are the ones used in Sonic CD
-----------------------------------------------------------------------
*/
// Result OK
#define RESULT_OK 0x64
// Error in core load_data_sub subroutine
#define RESULT_LOAD_FAIL 0xff9c
// Error occurred when trying to load file list from directory
#define RESULT_DIR_FAIL 0xffff
// File not found when trying to load file
#define RESULT_NOT_FOUND 0xfffe
// Error in load_data_sub while trying to load a file
#define ACCRES_LOAD_FILE_ERR 0xfffd

/**
 * Access Operations
 * Place this value in `access_op` to trigger the process
 */
#define ACC_OP_IDLE 0
#define ACC_OP_LOAD_DIR 1
#define ACC_OP_LOAD_DMA_WORD 2
#define ACC_OP_LOAD_SUB 3
#define ACC_OP_LOAD_DMA_PRG 4
#define ACC_OP_LOAD_DMA_PCM 5
#endif