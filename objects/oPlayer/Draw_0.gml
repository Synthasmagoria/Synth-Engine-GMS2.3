///@desc Draw

// Draw the player
draw_sprite_ext(
	sprite_index,
	image_index,
	floor(x),
	floor(y) + (vertical_direction == -1) * upsidedown_draw_yoffset * abs(image_yscale),
	get_xscale(),
	get_yscale(),
	image_angle,
	image_blend,
	image_alpha)