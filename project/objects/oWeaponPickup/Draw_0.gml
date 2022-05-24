draw_self()

if active
	draw_sprite_ext_outline(
		object_get_sprite(weapon),
		0,
		x + sprite_width / 2,
		y + sprite_height / 2,
		image_xscale * sin(time),
		image_yscale,
		image_angle,
		image_blend,
		image_alpha,
		1,
		c_gray);