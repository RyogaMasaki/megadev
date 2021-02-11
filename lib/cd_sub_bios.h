/**
 * \file cd_sub_bios.h
 * (Intended for Sub CPU usage only)
 */

#ifndef MEGADEV__CD_SUB_BIOS_H
#define MEGADEV__CD_SUB_BIOS_H

#include "cd_sub_bios_def.h"
#include "types.h"

inline void BIOS_MSCSTOP() {
  register u16 d0_fcode asm("d0") = MSCSTOP;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_MSCPAUSEON() {
  register u16 d0_fcode asm("d0") = MSCPAUSEON;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_MSCPAUSEOFF() {
  register u16 d0_fcode asm("d0") = MSCPAUSEOFF;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_MSCSCANFF() {
  register u16 d0_fcode asm("d0") = MSCSCANFF;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_MSCSCANFR() {
  register u16 d0_fcode asm("d0") = MSCSCANFR;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_MSCSCANOFF() {
  register u16 d0_fcode asm("d0") = MSCSCANOFF;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_ROMPAUSEON() {
  register u16 d0_fcode asm("d0") = ROMPAUSEON;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_ROMPAUSEOFF() {
  register u16 d0_fcode asm("d0") = ROMPAUSEOFF;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_DRVOPEN() {
  register u16 d0_fcode asm("d0") = DRVOPEN;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

struct DRVINIT_PARAM {
  u8 toc_track_number;
  u8 last_track;
}

inline void
BIOS_DRVINIT(struct DRVINIT_PARAM const* drvinit_param) {
  register u16 d0_fcode asm("d0") = DRVINIT;
  register struct DRVINIT_PARAM const* a0_drvinit_param asm("a0") =
      drvinit_param;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_drvinit_param));
};

inline void BIOS_MSCPLAY(u16 const* track_number) {
  register u16 d0_fcode asm("d0") = MSCPLAY;
  register u16 const* a0_track_number asm("a0") = track_number;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_track_number));
};

inline void BIOS_MSCPLAY1(u16 const* track_number) {
  register u16 d0_fcode asm("d0") = MSCPLAY1;
  register u16 const* a0_track_number asm("a0") = track_number;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_track_number));
};

inline void BIOS_MSCPLAYR(u16 const* track_number) {
  register u16 d0_fcode asm("d0") = MSCPLAYR;
  register u16 const* a0_track_number asm("a0") = track_number;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_track_number));
};

inline void BIOS_MSCPLAYT(u32 const* time_code) {
  register u16 d0_fcode asm("d0") = MSCPLAYT;
  register u16 const* a0_time_code asm("a0") = time_code;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_time_code));
};

inline void BIOS_MSCSEEK(u32 const* track_number) {
  register u16 d0_fcode asm("d0") = MSCSEEK;
  register u16 const* a0_track_number asm("a0") = track_number;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_track_number));
};

inline void BIOS_MSCSEEKT(u32 const* time_code) {
  register u16 d0_fcode asm("d0") = MSCSEEKT;
  register u16 const* a0_time_code asm("a0") = time_code;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_time_code));
};

inline void BIOS_ROMREAD(u32 const* sector_number) {
  register u16 d0_fcode asm("d0") = ROMREAD;
  register u32 const* a0_sector_number asm("a0") = sector_number;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_sector_number));
};

inline void BIOS_ROMSEEK(u32 const* sector_number) {
  register u16 d0_fcode asm("d0") = ROMSEEK;
  register u32 const* a0_sector_number asm("a0") = sector_number;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_sector_number));
};

inline void BIOS_MSCSEEK1(u16 const* track_number) {
  register u16 d0_fcode asm("d0") = MSCSEEK1;
  register u16 const* a0_track_number asm("a0") = track_number;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_track_number));
};

struct ROMREADN_PARAM {
  u32 start_sector;
  u32 sector_count;
}

inline void
BIOS_ROMREADN(struct ROMREADN_PARAM const* romreadn_param) {
  register u16 d0_fcode asm("d0") = ROMREADN;
  register u32 const* a0_romreadn_param asm("a0") = romreadn_param;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_romreadn_param));
};

inline void BIOS_ROMREADE(struct ROMREADN_PARAM const* romreade_param) {
  register u16 d0_fcode asm("d0") = ROMREADE;
  register u32 const* a0_romreade_param asm("a0") = romreade_param;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_romreade_param));
};

inline void BIOS_CDBCHK(u32 const* sector_number) {
  register u16 d0_fcode asm("d0") = CDBCHK;
  register u32 const* a0_sector_number asm("a0") = sector_number;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_sector_number));
};

inline void BIOS_CDBSTAT() {
  register u16 d0_fcode asm("d0") = CDBSTAT;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
}

inline void BIOS_FDRSET(u16 const volume) {
  register u16 d0_fcode asm("d0") = FDRSET;
  register u16 const d1_volume asm("d1") = volume;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "d"(d1_volume));
};

inline void BIOS_FDRCHG(u32 const volume) {
  register u16 d0_fcode asm("d0") = FDRCHG;
  register u32 const d1_volume asm("d1") = volume;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "d"(d1_volume));
};

inline void BIOS_CDCSTART() {
  register u16 d0_fcode asm("d0") = CDCSTART;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_CDCSTOP() {
  register u16 d0_fcode asm("d0") = CDCSTOP;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_CDCSTAT() {
  register u16 d0_fcode asm("d0") = CDCSTAT;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_CDCREAD() {
  register u16 d0_fcode asm("d0") = CDCREAD;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

inline void BIOS_CDCTRN(u8* sector_dest, u8* header_dest) {
  register u16 d0_fcode asm("d0") = CDCTRN;
  register u8* a0_sector_dest asm("a0") = sector_dest;
  register u8* a1_header_dest asm("a1") = header_dest;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode), "a"(a0_sector_dest),
      "a"(a1_header_dest));
};

inline void BIOS_CDCACK() {
  register u16 d0_fcode asm("d0") = CDCACK;
  asm("jsr %p0" ::"i"(_CDBIOS), "d"(d0_fcode));
};

#endif