/**
 * echo.h
 * Echo sound driver control
 */

#ifndef MEGADEV__ECHO_H
#define MEGADEV__ECHO_H

#include "types.h"

extern void echo_init_c(u8 data[]);

extern void echo_send_command(u8 command);

extern void echo_send_command_ex(u8 command, u8 data[]);

extern void echo_send_command_byte(u8 command, u8 param);

extern void echo_play_sfx(u8 data[]);

extern void echo_stop_sfx();

extern void echo_play_bgm(u8 data[]);

extern void echo_stop_bgm();

extern void echo_pause_bgm();

extern void echo_resume_bgm();

extern void echo_play_direct(u8 data[]);

extern void echo_set_pcm_rate(u8 rate);

extern void echo_set_stereo(bool enable_stereo);

extern void echo_set_volume(u8 volume);

extern void echo_set_volume_ex(u8 data[]);

extern u8 echo_get_status();

extern u8 echo_get_flags();

extern void echo_set_flags(u8 flags);

extern void echo_clear_flags(u8 clear_mask);

extern void echo_convert_list(u8 data[]);

#endif
