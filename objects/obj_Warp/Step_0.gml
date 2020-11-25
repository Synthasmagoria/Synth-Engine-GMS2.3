///@desc Warp

if (place_meeting(x, y, obj_Player)) {
	if (warp_x != 0 || warp_y != 0)
		warp(warp_room, obj_Player, warp_x, warp_y, false, false, true);
	else
		warp(warp_room, obj_Player, 0, 0, false, true);
}