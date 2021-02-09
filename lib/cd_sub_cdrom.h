/**
 * \file cd_sub_cdrom.h
 * CD-ROM File Access API
 */

#ifndef MEGADEV__CD_SUB_CDROM_H
#define MEGADEV__CD_SUB_CDROM_H

#include "cd_sub_cdrom_def.h"
#include "types.h"

/**
 * Pointer to the buffer to store the output file
 * This is only used with the Sub CPU Direct Load operation!
 * For the DMA operations, use the GA_DMAADDR register
 */
extern u8 const* file_dest_ptr;

/**
 * Pointer to the filename string
 * The filename is in 8.3 format, made up of ISO9660
 * d characters, and include the version suffix
 */
extern u8 const* filename_ptr;

/**
 * Place an access operation value in this variable to begin
 * a load process
 */
extern u16 access_op;

#endif