///@desc Save

animation_counter = max(animation_counter - 1, 0)

if (instance_exists(oPlayer) &&
	(place_meeting(x, y, oWeaponProjectile) ||
	(place_meeting(x, y, oPlayer) && keyboard_check_pressed(global.button[BUTTON.SHOOT])))) {
	
	animation_counter = animation_length
	
	savedata_save_player()
}

image_index = sign(animation_counter)