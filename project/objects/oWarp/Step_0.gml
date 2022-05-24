///@desc Warp

if (place_meeting(x, y, oPlayer)) {
	if (warp_x != 0 || warp_y != 0)
		warp(warp_room, oPlayer, warp_x, warp_y, false, false, true)
	else
		warp(warp_room, oPlayer, 0, 0, false, true)
}