/// @desc

if (!instance_exists(obj_Player)) {
	player_spawn(
		x + sprite_width / 2 + sprite_get_xoffset(object_get_mask(obj_Player)),
		bbox_bottom - sprite_get_yoffset(object_get_mask(obj_Player)));
		
	if (save)
		player_save();
}