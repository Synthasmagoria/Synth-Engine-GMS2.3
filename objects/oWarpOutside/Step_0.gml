///@desc Warp

if (place_meeting(x, y, oPlayer) && !persistent)
{
	if room == warp_room
	{
		if oPlayer.x < 0
			oPlayer.x += room_width
		else if oPlayer.x > room_width
			oPlayer.x -= room_width
		
		if oPlayer.y < 0
			oPlayer.y += room_height
		else if oPlayer.y > room_height
			oPlayer.y -= room_height
		
		oPlayer.x += warp_xoffset
		oPlayer.y += warp_yoffset
	}
	else
	{
		leave_x = (oPlayer.x > room_width) - (oPlayer.x < 0)
		leave_y = (oPlayer.y > room_height) - (oPlayer.y < 0)
	
		if (leave_x != 0 || leave_y != 0)
		{
			room_goto(warp_room)
			persistent = true
		}
	}
}