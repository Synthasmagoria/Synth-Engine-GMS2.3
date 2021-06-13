///@desc

if collision_rectangle(
	bbox_right - 2,
	bbox_top - 2,
	bbox_left + 1,
	bbox_bottom + 1,
	oPlayer,
	false,
	false) && !visible {
	visible = true
	sfx_play_sound(sound)
}