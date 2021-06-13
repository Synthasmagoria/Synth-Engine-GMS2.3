///@desc Switch to camera with the set index

if (instance_exists(oPlayer) &&
	point_in_rectangle(oPlayer.x, oPlayer.y, bbox_left, bbox_top, bbox_right, bbox_bottom) &&
	current != index) {
	
	current = index
	
	with (oCameraParent)
		if (index == other.index)
			activate()
	
	with (oCameraTrigger)
		current = other.index
}