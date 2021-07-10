///@desc Warp

if (place_meeting(x, y, oPlayer) && !persistent)
{
	leave_x = (oPlayer.x > room_width) - (oPlayer.x < 0)
	leave_y = (oPlayer.y > room_height) - (oPlayer.y < 0)
	
	if (leave_x != 0 || leave_y != 0)
	{
		room_goto(warp_room)
		persistent = true
	}
}