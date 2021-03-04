/**
 * \file cd_sub_cdrom.h
 * CD-ROM File Access API
 */

#ifndef MEGADEV__CD_SUB_CDROM_H
#define MEGADEV__CD_SUB_CDROM_H

#include "cd_sub_cdrom_def.h"
#include "types.h"

/**
 * \var file_buff
 * \brief Pointer to the buffer to store the output file
 * \note This is only used with the Sub CPU Direct Load operation!
 * For the DMA operations, use the GA_DMAADDR register
 */
extern u8 const* file_buff;

/**
 * \var filename
 * \brief Pointer to the filename string
 * \details The filename is in 8.3 format, made up of ISO9660 d characters, and
 * includes the version suffix
 */
extern u8 const* filename;

/**
 * \var access_op
 * \brief Place an access operation value in this variable to begin
 * a load process
 */
extern u16 access_op;

#endif