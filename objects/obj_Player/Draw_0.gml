///@desc Player animation

if (situated)
	sprite_index = running ? spr_PlayerRun : spr_PlayerIdle;
else
	sprite_index = vspeed < 0 ? spr_PlayerJump : spr_PlayerFall;


draw_sprite_ext(
	sprite_index,
	image_index,
	floor(x), 
	y,
	facing,
	1,
	0,
	c_white,
	1.0);