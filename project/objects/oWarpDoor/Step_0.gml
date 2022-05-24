///@desc Warp

// Check if touching
event_user(0)

// Warp if conditions are met
if (warp_touching && input_check_pressed("up"))
	event_user(1)