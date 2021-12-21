/*
	If something doesn't have the correct volume then you should
	check if they're in the right audio group
	audiogroup_default - music
	audiogroup_sound - sfx
*/

///@desc				Gets music to be played in a room
///@func				bgm_get_room_music(room)
///@arg 				room
function bgm_get_room_music(r) {
	switch (r) {
		case rTest:
		case rTest2:
			return musEngine
			break
		case rBlank:
			return -2
			break
		default:	
			return -1
			break
	}
}

///@desc	Get pitch of the music to be played in a room
///@func	bgm_get_room_music_pitch(room)
///@arg		room
function bgm_get_room_music_pitch(r) {
	switch (r) {
		case rTest2:
			return 0.8
			break
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
		case rTest2:
			return 0.8
			break
		default:
			return 1.0
			break
	}
}