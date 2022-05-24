///@desc Save

animation_counter = max(animation_counter - 1, 0)

if instance_exists(oPlayer) &&
	((place_meeting(x, y, oWeaponProjectile) && animation_counter == 0) || (place_meeting(x, y, oPlayer) && input_check_pressed("shoot"))) {
	
	animation_counter = animation_length
	
	savedata_save_player()
}

image_index = sign(animation_counter)