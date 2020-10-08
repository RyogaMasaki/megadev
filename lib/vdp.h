#ifndef MEGADEV__VDP_H
#define MEGADEV__VDP_H

extern void vdp_load_registers_c(char const *vdp_regs);
extern void vblank_wait();
extern void vram_clear();
extern void cram_clear();
extern void vram_load_tiles_c(void *tile_data, int data_size, int tile_offset);
extern void cram_load_palette_c(void *color_data, int color_count,
                                int color_entry_offset);
#endif
