
/*
	A note about audio_sound_pitch (20.06.2021)
	in the manual is says that audio_sound_pitch takes a multiplier
	This was not true when I wrote this code. If you have issues with audio pitching
	then this might be why. In case this changes or something please contact me on
	discord Synthasmagoria#6751
*/

// Load sound effect audio group (audiogroup_default is for music)
if (!audio_group_is_loaded(audiogroup_sound)) 
	audio_group_load(audiogroup_sound)

music = -1
music_id = noone

sfx_id = ds_list_create()
sfx_pos = ds_list_create()
sfx_time = 0

if instance_number(object_index) > 1 {
	instance_destroy()
}