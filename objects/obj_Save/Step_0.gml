///@desc Save

animation_counter = max(animation_counter - 1, 0);

if (place_meeting(x, y, obj_Bullet) && instance_exists(obj_Player)) {
	
	animation_counter = animation_length;
	
	player_save();
}

image_index = sign(animation_counter);