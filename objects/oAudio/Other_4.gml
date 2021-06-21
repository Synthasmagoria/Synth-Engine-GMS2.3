
var _music = bgm_get_room_music(room)

if _music != -2 {
    if _music == -1 {
        bgm_stop_music()
    } else if _music != music {
        bgm_stop_music()
        music = _music
        music_id = audio_play_sound(music, 1, true)
    }
}

if music_id != noone {
    audio_sound_gain(music_id, bgm_get_room_music_gain(room), 0)
	
    if (audio_sound_get_pitch(music_id) != bgm_get_room_music_pitch(room))
    	bgm_set_pitch(bgm_get_room_music_pitch(room))
}