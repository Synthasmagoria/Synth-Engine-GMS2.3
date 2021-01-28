
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

draw_self();

draw_sprite_ext(mask_index, 0, x, y, 1, 1, image_angle, c_white, 1.0);

draw_line(x, y, x + total_speed.x * 4, y + total_speed.y * 4);