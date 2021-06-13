// Handle effects queue
sfx_time += f2sec(1)
if ds_list_size(sfx_id) > 0 && sfx_pos[|0] < sfx_time {
	ds_list_delete(sfx_id, 0)
	ds_list_delete(sfx_pos, 0)
}