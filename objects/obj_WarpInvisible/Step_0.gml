///@desc Warp

if (instance_exists(obj_Player) && position_meeting(obj_Player.x, obj_Player.y, id))
	warp(warp_room, obj_Player, warp_xoffset, warp_yoffset);