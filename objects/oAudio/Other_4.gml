// Set room music
var
_music = bgm_get_room_music(room)

if _music != -2 {
    if _music == -1 {
        if audio_is_playing(music_id)
            audio_stop_sound(music_id)
        
        music = _music
        music_id = -1
    } else if _music != music {
        if audio_is_playing(music_id)
            audio_stop_sound(music_id)
        
        music = _music
        music_id = audio_play_sound(music, 1, true)
    }
}

if music_id != -1 {
    audio_sound_gain(music_id, bgm_get_room_music_gain(room), 0)
     
    var
    _pitch = bgm_get_room_music_pitch(room),
    _curPitch = audio_sound_get_pitch(music_id)
    
    if (_curPitch != _pitch)
    	audio_sound_pitch(music_id, _curPitch * (_pitch / _curPitch))
}

// Stop sound effects and clear queue
for (var i = ds_list_size(sfx_id) - 1; i >= 0; i--)
	audio_stop_sound(sfx_id[|i])

ds_list_clear(sfx_id)
ds_list_clear(sfx_pos)