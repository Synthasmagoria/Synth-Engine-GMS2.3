/// @desc

if (!instance_exists(oPlayer)) {
	player_spawn(
		x + sprite_width / 2 + sprite_get_xoffset(object_get_mask(oPlayer)),
		bbox_bottom - sprite_get_yoffset(object_get_mask(oPlayer)))
		
	if (save)
		savedata_save_player()
}