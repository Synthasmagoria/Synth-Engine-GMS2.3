///@desc Check if touching

warp_touching = instance_exists(obj_Player) &&
	(rectangle_in_rectangle(
		obj_Player.bbox_left, obj_Player.bbox_top, obj_Player.bbox_right, obj_Player.bbox_bottom,
		bbox_left + 1, bbox_top, bbox_right - 1, bbox_bottom) == 1);