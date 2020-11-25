///@desc Warp

if (place_meeting(x, y, obj_Player) && !persistent)
{
	leave_x = (obj_Player.x > room_width) - (obj_Player.x < 0);
	leave_y = (obj_Player.y > room_height) - (obj_Player.y < 0);
	
	if (leave_x != 0 || leave_y != 0)
	{
		room_goto(warp_room);
		persistent = true;
	}
}