///@desc Position player

if (persistent)
{
	if (leave_x == -1)
		oPlayer.x += room_width
	else if (leave_x == 1)
		oPlayer.x -= room_width_previous
	
	oPlayer.x += warp_xoffset
	
	if (leave_y == -1)
		oPlayer.y += room_height
	else if (leave_y == 1)
		oPlayer.y -= room_height_previous
	
	oPlayer.y += warp_yoffset
		
	if (room != room_origin)
		instance_destroy()
	else
		persistent = false
}