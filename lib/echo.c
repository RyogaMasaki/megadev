/**
 * echo.c
 * Echo sound driver control
 */

#ifndef MEGADEV__ECHO_C
#define MEGADEV__ECHO_C

#include "types.h"

void echo_init_c(u8 data[]) {
  register u32 a0_data asm("a0") = (u32)data;
  asm("jsr echo_init" :: "a"(a0_data));
};

void echo_send_command(u8 command) {
	register u8 d0_command asm("d0") = command;

  asm("jsr Echo_SendCommand" ::"d"(d0_command));

};

void echo_send_command_ex(u8 command, u8 data[]) {
	register u8 d0_command asm("d0") = command;
	register u32 a0_data asm("a0") = (u32)data;

	asm("jsr Echo_SendCommandEx" ::"d"(d0_command), "a"(a0_data));

};

void echo_send_command_byte(u8 command, u8 param) {
	register u8 d0_command asm("d0") = command;
	register u8 d1_param asm("d1") = param;

	asm("jsr Echo_SendCommandByte" :: "d"(d0_command), "d"(d1_param));

};

void echo_play_sfx(u8 data[]) {
  register u32 a0_data asm("a0") = (u32)data;

	asm("jsr Echo_PlaySFX" :: "a"(a0_data));

};

void echo_play_bgm(u8 data[]) {
  register u32 a0_data asm("a0") = (u32)data;
  asm("jsr Echo_PlayBGM" :: "a"(a0_data));
};


void echo_play_direct(u8 data[]) {
  register u32 a0_data asm("a0") = (u32)data;
  asm("jsr Echo_PlayDirect" :: "a"(a0_data));
};


void echo_set_pcm_rate(u8 rate){
  register u8 d0_rate asm("d0") = rate;
	asm("jsr Echo_SetPCMRate" ::"d"(d0_rate));
};


void echo_set_stereo(bool enable_stereo){
	register u8 d0_enable_stereo asm("d0") = enable_stereo;
	asm("jsr Echo_SetStereo" ::"d"(d0_enable_stereo));
};


void echo_set_volume(u8 volume) {
	register u8 d0_volume asm("d0") = volume;
	asm("jsr Echo_SetVolume" ::"d"(d0_volume));
};


void echo_set_volume_ex(u8 data[]) {
  register u32 a0_data asm("a0") = (u32)data;
  asm("jsr Echo_SetVolumeEx" :: "a"(a0_data));
};

u8 echo_get_status() {
	register u8 d0_status asm("d0");
	asm("jsr Echo_GetStatus" : "=d"(d0_status));
	return d0_status;
};

u8 echo_get_flags() {
	register u8 d0_flags asm("d0");
	asm("jsr Echo_GetFlags" : "=d"(d0_flags));
	return d0_flags;
};


void echo_set_flags(u8 flags) {
	register u8 d0_flags asm("d0") = flags;
	asm("jsr Echo_SetFlags" ::"d"(d0_flags));
};

void echo_clear_flags(u8 clear_mask) {
	register u8 d0_clear_mask asm("d0") = clear_mask;
	asm("jsr Echo_ClearFlags" ::"d"(d0_clear_mask));
};

void echo_convert_list(u8 data[]) {
	  register u32 a0_data asm("a0") = (u32)data;
  asm("jsr echo_convert_inst_list" :: "a"(a0_data));
};

#endif
