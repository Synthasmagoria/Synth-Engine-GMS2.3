music = -1
music_id = -1

sfx_id = ds_list_create()
sfx_pos = ds_list_create()
sfx_time = 0

sfx_add = function(snd_id) {
	var _pos = sfx_time + audio_sound_length(snd_id)
	ds_list_add(sfx_pos, _pos)
	ds_list_sort(sfx_pos, true)
	_pos = ds_list_find_index(sfx_pos, _pos)
	ds_list_insert(sfx_id, _pos, snd_id)
}