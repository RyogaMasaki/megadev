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

/**
 * \def RESULT_OK
 * \brief No problems during the process
 */
#define RESULT_OK 0x64

/**
 * \def RESULT_LOAD_FAIL
 * \brief Error in core load_data_sub routine
 */
#define RESULT_LOAD_FAIL 0xff9c
/**
 * \def RESULT_DIR_FAIL
 * \brief Error occurred when trying to load file list from directory
 */
#define RESULT_DIR_FAIL 0xffff
/**
 * \def RESULT_NOT_FOUND
 * \brief Filename not found on load attempt
 */
#define RESULT_NOT_FOUND 0xfffe

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