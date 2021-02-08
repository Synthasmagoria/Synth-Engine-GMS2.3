/*
	obj_World calls some of these functions in room_start
*/

///@desc				Gets music to be played in a room
///@func				world_get_room_music(room)
///@arg 				room
function world_get_room_music(r) {
	switch (r) {
		case rm_Stage01:
		case rm_NStage:
			return mus_Engine;
			break;
		
		default:		
			return -1;
			break;
	}
}

///@desc	Get pitch of the music to be played in a room
///@func	world_get_room_music_pitch(room)
///@arg		room
function world_get_room_music_pitch(r) {
	switch (r) {
		case rm_NStage:
			return 0.5;
			break;
		
		default:
			return 1.0;
			break;
	}
}

///@desc	Get gain of the music to be played in a room
///@func	world_get_room_music_gain(room)
///@arg		room
function world_get_room_music_gain(r) {
	switch (r) {
		case rm_NStage:
			return 0.5;
			break;
			
		default:
			return 1.0;
			break;
	}
}

///@desc			Fades out previous music, returns its index and fades in new music
///@func			world_crossfade_music(snd, time_ms)
///@arg snd			New sound to play
///@arg time_ms		Length of the crossfade in ms
function world_crossfade_music(snd, time_ms) {
	var mus = world_get_music_index();
	audio_sound_gain(mus, 0.0, time_ms);

	var newmus = world_set_music(snd);
	audio_sound_gain(newmus, 0.0, 0);
	audio_sound_gain(newmus, 1.0, time_ms);

	return mus;
}

///@desc Gets the currently playing music
///@func world_get_music()
function world_get_music() {
	return obj_World.music;
}

///@desc Gets the index of the currently playing music
///@func world_get_music_index()
function world_get_music_index() {
	return obj_World.music_index;
}

///@desc Stops the music played by the world object
///@func world_stop_music()
function world_stop_music() {
	if (audio_is_playing(obj_World.music_index))
		audio_stop_sound(obj_World.music_index);
}

///@desc Sets the music played by the world object (doesn't stop the currently playing music)
///@func world_set_music(snd)
///@arg snd
function world_set_music() {
	obj_World.music = argument[0];
	obj_World.music_index = audio_play_sound(argument[0], 0, true);
	return obj_World.music_index;
}