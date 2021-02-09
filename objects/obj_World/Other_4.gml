///@desc Room music

// Reset reset variables
resetting_room = -1;

// Clear blood particles
part_particles_clear(global.player_blood_part_sys);

// Set room music
var
_music = world_get_room_music(room),
_musicIsPlaying = true;

if (music != _music)
{
	if (!audio_is_playing(_music))
	{
		if (audio_is_playing(music_index))
		{
			audio_stop_sound(music_index);
			music_index = -1;
		}
		
		if (_music != -1)
		{
			music_index = audio_play_sound(_music, 100, true);
		}
		else
		{
			_musicIsPlaying = false;
		}
	}
	
	music = _music;
}

// Set room music pitch and gain
if (_musicIsPlaying)
{
	audio_sound_gain(world_get_room_music_gain(room), 1, 0);
	
	var
	_pitch = world_get_room_music_pitch(room),
	_curPitch = audio_sound_get_pitch(music_index);
	
	if (_curPitch != _pitch)
		audio_sound_pitch(music_index, _curPitch * (_pitch / _curPitch));
}