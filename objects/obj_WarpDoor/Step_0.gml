///@desc Warp

// Check if touching
event_user(0);

// Warp if conditions are met
if (warp_touching && keyboard_check_pressed(g.button[BUTTON.UP]))
	event_user(1);