///@desc Warp

// Check if touching
do_collision()

// Warp if conditions are met
if (warp_touching && input_check_pressed("up"))
	door_warp()