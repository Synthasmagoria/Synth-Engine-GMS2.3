
if (situated) {
	if (running)
		sprite_index = spr_PlayerRun;
	else
		sprite_index = spr_PlayerIdle;
} else if (on_vine) {
	sprite_index = spr_PlayerSlide;
} else {
	if (grav_spd < 0.0)
		sprite_index = spr_PlayerJump;
	else
		sprite_index = spr_PlayerFall;
}

draw_sprite_ext(
	sprite_index,
	image_index,
	x,
	y,
	facing * image_xscale,
	image_yscale,
	image_angle,
	image_blend,
	image_alpha);

draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, image_blend, 0.5);

draw_line(x, y, x + total_speed.x * 4, y + total_speed.y * 4);