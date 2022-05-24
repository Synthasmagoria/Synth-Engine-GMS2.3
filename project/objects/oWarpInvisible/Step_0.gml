///@desc Warp

if (instance_exists(oPlayer) && position_meeting(oPlayer.x, oPlayer.y, id))
	warp(warp_room, oPlayer, warp_xoffset, warp_yoffset)