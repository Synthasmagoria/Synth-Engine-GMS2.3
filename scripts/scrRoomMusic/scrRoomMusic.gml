/*
	These functions are called by oAudio to figure out what to play, where to play it, and how to play it
	You can change these switch statements to set the song playing in a room, its pitch and gain
*/

///@desc				Gets music to be played in a room
///@func				bgm_get_room_music(room)
///@arg 				room
function bgm_get_room_music(r) {
	switch (r) {
		case rBlank:
			return -2 // don't change currently playing
			break
		case rEngine:
			return musEngine
			break
		default:
			return -1 // don't play any music
			break
	}
}

///@desc	Get pitch of the music to be played in a room
///@func	bgm_get_room_music_pitch(room)
///@arg		room
function bgm_get_room_music_pitch(r) {
	switch (r) {
		default:
			return 1.0
			break
	}
}

///@desc	Get gain of the music to be played in a room
///@func	bgm_get_room_music_gain(room)
///@arg		room
function bgm_get_room_music_gain(r) {
	switch (r) {
		default:
			return 1.0
			break
	}
}