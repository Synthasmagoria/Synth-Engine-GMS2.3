
if (situated) {
	if (running)
		sprite_index = spr_PlayerRun;
	else
		sprite_index = spr_PlayerIdle;
} else {
	if (grav_spd < 0.0)
		sprite_index = spr_PlayerJump;
	else
		sprite_index = spr_PlayerFall;
}

image_xscale = abs(image_xscale) * facing;

draw_self();

draw_text_outline(x, y, "on_slope: " + string(on_slope), c_black);