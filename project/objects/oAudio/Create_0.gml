/*
	If something doesn't have the correct volume then you should
	check if they're in the right audio group
	audiogroup_default - music
	audiogroup_sound - sfx
*/

// Load sound effect audio group (audiogroup_default is for music)
if (!audio_group_is_loaded(audiogroup_sound)) 
	audio_group_load(audiogroup_sound)

global.audio = id

music = -1
music_id = noone

sfx_id = ds_list_create()
sfx_pos = ds_list_create()
sfx_time = 0

if instance_number(object_index) > 1 {
	instance_destroy()
}