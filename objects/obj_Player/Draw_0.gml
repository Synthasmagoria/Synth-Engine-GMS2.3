
// Pick the right sprite
if (situated)
{
	if (running)
		sprite_index = spr_PlayerRun;
	else
		sprite_index = spr_PlayerIdle;
}
else if (vine_direction != 0)
{
	sprite_index = spr_PlayerSlide;
}
else
{
	if (vspeed * vertical_direction < 0.0)
		sprite_index = spr_PlayerJump;
	else
		sprite_index = spr_PlayerFall;
}

// Draw the player
draw_sprite_ext(
	sprite_index,
	image_index,
	floor(x),
	floor(y),
	image_xscale * facing,
	image_yscale,
	image_angle,
	image_blend,
	image_alpha);