/**
 * \file io.h
 * I/O 
 */

#ifndef MEGADEV__IO_H
#define MEGADEV__IO_H

#include "types.h"
#include "io_def.h"

extern u16 input_p1;
extern u16 input_p2;

extern u8 input_p1_hold;
extern u8 input_p1_press;

void update_inputs_c();

void put_ext(u8 value);

void init_ext_c();

u8 get_ext();

#endif
