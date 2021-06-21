///@func	sfx_play_sound(snd, priority)
///@arg {sound} snd
function sfx_play_sound(snd) {
	var _id = audio_play_sound(snd, 0, false)
	sfx_add(_id)
	return _id
}

///@func	sfx_add(snd_id)
///@arg {sound} snd_id
function sfx_add(snd_id) {
	with global.audio {
		var _pos = sfx_time + audio_sound_length(snd_id)
		ds_list_add(sfx_pos, _pos)
		ds_list_sort(sfx_pos, true)
		_pos = ds_list_find_index(sfx_pos, _pos)
		ds_list_insert(sfx_id, _pos, snd_id)
	}
}

///@func sfx_stop_all()
function sfx_stop_all() {
	with global.audio {
		for (var i = ds_list_size(sfx_id) - 1; i >= 0; i--)
			audio_stop_sound(sfx_id[|i])
		ds_list_clear(sfx_id)
		ds_list_clear(sfx_pos)
	}
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
	return global.audio.music
}

///@desc Gets the index of the currently playing music
///@func bgm_get_music_id()
function bgm_get_music_id() {
	return global.audio.music_id
}

///@desc Stops the music played by the world object
///@func bgm_stop_music()
function bgm_stop_music() {
	if (audio_is_playing(global.audio.music_id)) {
		audio_sound_pitch(global.audio.music_id, 1) // reset pitch before stopping sound to mitigate a bug in runtime v2.3.2.476
		audio_stop_sound(global.audio.music_id)
	}
	global.audio.music_id = noone
	global.audio.music = -1
}

///@desc Sets the music played by the world object (doesn't stop the currently playing music)
///@func bgm_set_music(snd)
///@arg snd
function bgm_set_music(snd) {
	global.audio.music = snd
	global.audio.music_id = audio_play_sound(snd, 0, true)
	return global.audio.music_id
}

///@func bgm_set_pitch(pitch)
function bgm_set_pitch(pitch) {
	audio_sound_pitch(global.audio.music_id, pitch)
}