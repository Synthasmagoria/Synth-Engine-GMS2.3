///@desc Room music

// Reset reset variables
resetting_room = -1;

// Clear blood particles
part_particles_clear(g.player_blood_part_sys);

// Set room music
var mus;

switch (room) {
	case rm_Initialize:
		mus = -2;		// No music
		break;
	
	default:			
		mus = -1;		// Don't change the music
		break;
}

if (audio_is_playing(music_index))
	audio_sound_gain(music_index, 1, 0);

if (music != mus && mus != -2) {
	
	if (audio_is_playing(mus))
	{
		music = mus;
	}
	else
	{
		music = mus;
	
		if (audio_is_playing(music_index))
		{
			audio_stop_sound(music_index);
			music_index = -1;
		}
		
		if (music != -1)
			music_index = audio_play_sound(music, 0, true);
	}
}