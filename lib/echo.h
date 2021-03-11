/**
 * \file echo.h
 * \brief Echo sound driver control wrappers
 */

#ifndef MEGADEV__ECHO_H
#define MEGADEV__ECHO_H

#include "types.h"

/**
 * \fn echo_init_c
 * \brief Initialize driver with default settings and load instrument list
 * \param[in] data Array of converted instrument pointers
 * \note See \ref echo_convert_list
 */
inline void echo_init_c(u32 data[]) {
  register u32 a0_data asm("a0") = (u32)data;
  asm("jsr echo_init" :: "a"(a0_data));
};

/**
 * \fn echo_send_command
 * \brief Send command to Echo driver
 */
inline void echo_send_command(u8 command) {
	register u8 d0_command asm("d0") = command;
  asm("jsr Echo_SendCommand" ::"d"(d0_command) : "d1", "a1");
};

/**
 * \fn echo_send_command_ex
 * \brief Send a command to Echo driver with address parameter
 */
inline void echo_send_command_ex(u8 command, u8 data[]) {
	register u8 d0_command asm("d0") = command;
	register u32 a0_data asm("a0") = (u32)data;

	asm("jsr Echo_SendCommandEx" ::"d"(d0_command), "a"(a0_data) : "d1", "a1");

};

/**
 * \fn echo_send_command_byte
 * \brief Send a command to Echo driver with byte parameter
 */
inline void echo_send_command_byte(u8 command, u8 param) {
	register u8 d0_command asm("d0") = command;
	register u8 d1_param asm("d1") = param;
	asm("jsr Echo_SendCommandByte" :: "d"(d0_command), "d"(d1_param) : "d2", "a1");
};

/**
 * \fn echo_play_sfx
 * \brief Play a sound effect
 * \param[in] data Pointer to SFX data
 */
inline void echo_play_sfx(u8 data[]) {
  register u32 a0_data asm("a0") = (u32)data;
	asm("jsr Echo_PlaySFX" :: "a"(a0_data) : "d0", "d1", "a1");
};

/**
 * \fn echo_stop_sfx
 * \brief Stop currently playing sound effect
 */
inline void echo_stop_sfx() {
	asm("jsr Echo_StopSFX" ::: "d0", "d1", "a1");
}

/**
 * \fn echo_play_bgm
 * \brief Play background music
 * \param[in] data Pointer to BGM data
 */
inline void echo_play_bgm(u8 data[]) {
  register u32 a0_data asm("a0") = (u32)data;
  asm("jsr Echo_PlayBGM" :: "a"(a0_data) : "d0", "d1", "a1");
};

/**
 * \fn echo_stop_bgm
 * \brief Stops the currently playing background music
 */
inline void echo_stop_bgm() {
	asm("jsr Echo_StopBGM" ::: "d0", "d1", "a1");
}


/**
 * \fn echo_pause_bgm
 * \brief Pauses the currently playing background music
 */
inline void echo_pause_bgm() {
	asm("jsr Echo_PauseBGM" ::: "d0", "d1", "a1");
}

/**
 * \fn Echo_ResumeBGM
 * \brief Resume background music playback
 */
inline void echo_resume_bgm() {
	asm("jsr Echo_ResumeBGM" ::: "d0", "d1", "a1");
}

/**
 * \fn echo_play_direct
 * \brief Injects events into the BGM stream for the next tick.
 * \param[in] data Pointer to stream data
 */
inline void echo_play_direct(u8 data[]) {
  register u32 a0_data asm("a0") = (u32)data;
  asm("jsr Echo_PlayDirect" :: "a"(a0_data));
};

/**
 * \fn echo_set_pcm_rate
 * \brief Sets the playback rate of PCM
 * \param[in] rate New rate (timer A value)
 */
inline void echo_set_pcm_rate(u8 rate) {
  register u8 d1_rate asm("d1") = rate;
	asm("jsr Echo_SetPCMRate" ::"d"(d1_rate) ; "d0");
};

/**
 * \fn echo_set_stereo
 * \brief Enable/disable stereo output
 */
inline void echo_set_stereo(bool enable_stereo){
	register u8 d0_enable_stereo asm("d0") = enable_stereo;
	asm("jsr Echo_SetStereo" ::"d"(d0_enable_stereo));
};

/**
 * \fn echo_set_volume
 * \brief Set the global volume for every channel
 * \param[in] volume New volume \n (0: quiet, 255: loud)
 */
inline void echo_set_volume(u8 volume) {
	register u8 d0_volume asm("d0") = volume;
	asm("jsr Echo_SetVolume" ::"d"(d0_volume));
};

/**
 * \fn echo_set_volume_ex
 * \brief Change volume for individual channels
 * \param[in] data Pointer to volume structure
 * \details The volume structure is defined like so:
 *   8 bytes of FM channel volumes (0 to 127)
 *   4 bytes of PSG channel volumes (0 to 15)
 *   1 byte with PCM toggle (0 or 1)
 *   3 reserved (currently unused)
 * \todo Make this a struct for the C wrapper
 */
inline void echo_set_volume_ex(u8 data[]) {
  register u32 a0_data asm("a0") = (u32)data;
  asm("jsr Echo_SetVolumeEx" :: "a"(a0_data));
};

/**
 * \fn echo_get_status
 * \brief Get the current status of the Echo driver
 * \returns Driver status
 * \n Bit 0: SFX playing
 * \n Bit 1: BGM playing
 * \n Bit 14: Direct events not played
 * \n Bit 15: Command not yet parsed
 */
inline u8 echo_get_status() {
	register u8 d0_status asm("d0");
	asm("jsr Echo_GetStatus" : "=d"(d0_status));
	return d0_status;
};

inline u8 echo_get_flags() {
	register u8 d0_flags asm("d0");
	asm("jsr Echo_GetFlags" : "=d"(d0_flags));
	return d0_flags;
};

inline void echo_set_flags(u8 flags) {
	register u8 d0_flags asm("d0") = flags;
	asm("jsr Echo_SetFlags" ::"d"(d0_flags));
};


inline void echo_clear_flags(u8 clear_mask) {
	register u8 d0_clear_mask asm("d0") = clear_mask;
	asm("jsr Echo_ClearFlags" ::"d"(d0_clear_mask));
};

/**
 * \fn echo_convert_list
 * \brief Convert instrument pointer table to Echo format
 * \param[in] data Array of pointers to instruments, zero (long) terminated
 * \details Echo requires a list of all instruments as part of its init, and it
 * expects those pointer entries to be formatted in a specific way.
 * Unfortunately, due to the build/link process, we have no way of doing this
 * conversion at compile time as intended by Echo. (See the Echo_ListEntry
 * macro in the echo.68k source.) The reason for this is because we won't have
 * an actual memory address for the instruments until the actual link phase
 * at the end of compilation. As a workaround, we have this routine which
 * manually shifts around each pointer in the array to convert it to the
 * appropriate format. Therefore, you should call echo_convert_list() on your
 * pointer list before passing it to echo_init().
 * \note If anyone can think of a better way of doing this or doing the
 * conversion at compile time, a PR or discussion is appreciated.
 */
inline void echo_convert_list(u32 data[]) {
	register u32 a0_data asm("a0") = (u32)data;
  asm("jsr echo_convert_inst_list" :: "a"(a0_data));
};

#endif
