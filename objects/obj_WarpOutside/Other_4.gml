///@desc Position player

if (persistent)
{
	if (leave_x == -1)
		obj_Player.x += room_width;
	else if (leave_x == 1)
		obj_Player.x -= room_width_previous;
	
	obj_Player.x += warp_xoffset;
	
	if (leave_y == -1)
		obj_Player.y += room_height;
	else if (leave_y == 1)
		obj_Player.y -= room_height_previous;
	
	obj_Player.y += warp_yoffset;
		
	if (room != room_origin)
		instance_destroy();
	else
		persistent = false;
}