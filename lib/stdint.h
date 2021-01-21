/**
 * stdint.h
 * POSIX compatible stdint
 */

#ifndef MEGADEV__STDINT_H
#define MEGADEV__STDINT_H



/**
 *  \typedef s8
 *      8 bits signed integer (equivalent to char).
 */
typedef char int8_t;
typedef int8_t s8;

/**
 *  \typedef s16
 *      16 bits signed integer (equivalent to short).
 */
typedef short int16_t;
typedef int16_t s16;

/**
 *  \typedef s32
 *      32 bits signed integer (equivalent to long).
 */
typedef long int32_t;
typedef int32_t s32;

/**
 *  \typedef u8
 *      8 bits unsigned integer (equivalent to unsigned char).
 */
typedef unsigned char uint8_t;
typedef uint8_t u8;

/**
 *  \typedef u16
 *      16 bits unsigned integer (equivalent to unsigned short).
 */
typedef unsigned short uint16_t;
typedef uint16_t u16;

/**
 *  \typedef u32
 *      32 bits unsigned integer (equivalent to unsigned long).
 */
typedef unsigned long uint32_t;
typedef uint32_t u32;

#endif