///@desc Initialize variables

// Inherit
event_inherited()

// Set in creation code
warp_xoffset = 0
warp_yoffset = 0

// Internal variables
warp_touching = false

do_collision = function() {
	warp_touching = instance_exists(oPlayer) &&
	(rectangle_in_rectangle(
		oPlayer.bbox_left, oPlayer.bbox_top, oPlayer.bbox_right, oPlayer.bbox_bottom,
		bbox_left + 1, bbox_top, bbox_right - 1, bbox_bottom) == 1)
}

door_warp = function() {
	warp(warp_room, oPlayer, warp_xoffset, warp_yoffset)
}