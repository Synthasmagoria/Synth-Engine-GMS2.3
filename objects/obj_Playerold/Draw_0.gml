///@desc Player animation

if (situated)
	sprite_index = running ? spr_PlayerRun : spr_PlayerIdle;
else
	if (on_vine)
		sprite_index = spr_PlayerSlide;
	else
		sprite_index = vspeed < 0 ? spr_PlayerJump : spr_PlayerFall;


draw_sprite_ext(
	sprite_index,
	image_index,
	floor(x), 
	y,
	image_xscale * facing,
	image_yscale * vs_gravity_direction,
	image_angle,
	image_blend,
	image_alpha);