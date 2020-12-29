#include "dma.h"

void dma_wait_c() { asm("jsr dma_wait" ::: "d6"); };

void vdp_dma_transfer_vdpfmt(void const* source, u32 length, u32 vdpfmt_dest) {
  register u32 source_d0 asm("d0") = (u32)source;
  // TODO this is hardcoded for sega cd right now
  // (reading from PRG RAM needs to be address + 2)
  // change this with #define?
  if (source_d0 < 0xff0000) (source_d0 += 2);
  register u32 length_d1 asm("d1") = length;
  register u32 vdpfmt_dest_d2 asm("d2") = vdpfmt_dest;

  asm("jsr vdp_dma_transfer_sub" ::"d"(source_d0), "d"(length_d1),
      "d"(vdpfmt_dest_d2)
      : "a5");
};

void vdp_dma_transfer(void const* source, u32 length, u16 dest,
                      enum VDPADDR_BUS bus, enum VDPADDR_OP command) {
  vdp_dma_transfer_vdpfmt(source, length, VDP_ADDR(dest, bus, command));
};

void vdp_dma_fill(u8 value, u16 length, u32 vdpfmt_dest) {
  register u32 value_d0 asm("d0") = (u32)value;
  register u16 length_d1 asm("d1") = length;
  register u32 vdpfmt_dest_d2 asm("d2") = vdpfmt_dest;

  asm("jsr vdp_dma_fill_sub" ::"d"(value_d0), "d"(length_d1),
      "d"(vdpfmt_dest_d2)
      : "d3", "a5");
};

void dma_enqueue_c(u16 type, void const* source, u16 length, u32 vdpfmt_dest) {
  register u16 type_d0 asm("d0") = type;
  register u32 source_d1 asm("d1") = (u32)source;
  // TODO this is hardcoded for sega cd right now
  // (reading from PRG RAM needs to be address + 2)
  // change this with #define?
  if (type == 0 && source_d1 < 0xff0000) (source_d1 += 2);

  register u16 length_d2 asm("d2") = length;
  register u32 vdpfmt_dest_d3 asm("d3") = vdpfmt_dest;

  asm("jsr dma_enqueue" ::"d"(type_d0), "d"(source_d1), "d"(length_d2),
      "d"(vdpfmt_dest_d3)
      : "d4", "a5");
};

void dma_process_queue_c() { asm("jsr dma_process_queue"); }
