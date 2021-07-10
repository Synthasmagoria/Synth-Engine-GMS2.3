///@desc

if collision_rectangle(x - 2, y - 2, x + sprite_width + 2, y + sprite_height + 2, oPlayer, false, false) && !visible {
	visible = true
	sfx_play_sound(sound)
}