/*
	Functions used by and used for controlling oBGM
*/

///@func	sfx_play_sound(snd, priority)
///@desc	plays a garbage collected sound effect from the audio manager
///@arg {index} snd
///@arg {real} priority
function sfx_play_sound(snd) {
	var _id = audio_play_sound(snd, 0, false)
	oAudio.sfx_add(_id)
	return _id
}

///@desc			Fades out previous music, returns its id and fades in new music
///@func			bgm_crossfade(snd, time_ms)
///@arg snd			New sound to play
///@arg time_ms		Length of the crossfade in ms
function bgm_crossfade(snd, time_ms) {
	var mus = bgm_get_music_id()
	audio_sound_gain(mus, 0.0, time_ms)

	var newmus = bgm_set_music(snd)
	audio_sound_gain(newmus, 0.0, 0)
	audio_sound_gain(newmus, 1.0, time_ms)

	return mus
}

///@desc Gets the currently playing music
///@func bgm_get_music()
function bgm_get_music() {
	return oAudio.music
}

///@desc Gets the index of the currently playing music
///@func bgm_get_music_id()
function bgm_get_music_id() {
	return oAudio.music_id
}

///@desc Stops the music played by the world object
///@func bgm_stop_music()
function bgm_stop_music() {
	if (audio_is_playing(oAudio.music_id))
		audio_stop_sound(oAudio.music_id)
	oAudio.music_id = -1
	oAudio.music = -1
}

///@desc Sets the music played by the world object (doesn't stop the currently playing music)
///@func bgm_set_music(snd)
///@arg snd
function bgm_set_music(snd) {
	oAudio.music = snd
	oAudio.music_id = audio_play_sound(snd, 0, true)
	return oAudio.music_id
}