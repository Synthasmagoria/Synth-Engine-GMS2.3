///@desc Switch to camera with the set index

if (instance_exists(obj_Player) &&
	point_in_rectangle(obj_Player.x, obj_Player.y, bbox_left, bbox_top, bbox_right, bbox_bottom) &&
	current != index) {
	
	current = index;
	
	with (obj_CameraParent)
		if (index == other.index)
			activate();
	
	with (obj_CameraTrigger)
		current = other.index;
}