#ifndef MEGADEV__BRAM_H
#define MEGADEV__BRAM_H

#include "types.h"

enum BramStatus {
	SegaFormatted = 4,
	NoRam = 0,
	Unformatted = 1,
	OtherFormat = 2
};

typedef struct BramInitInfo {
	u16 bram_size;
	enum BramStatus status; 
} BramInitInfo;


extern u8 bram_work_ram[0x640];
 
extern u8 bram_string_buffer[12];

extern BramInitInfo init_info;


void bram_init_c();

s16 bram_find_file_c(u8 const* filename);


#endif