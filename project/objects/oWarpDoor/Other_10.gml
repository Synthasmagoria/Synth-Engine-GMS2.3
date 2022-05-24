///@desc Check if touching

warp_touching = instance_exists(oPlayer) &&
	(rectangle_in_rectangle(
		oPlayer.bbox_left, oPlayer.bbox_top, oPlayer.bbox_right, oPlayer.bbox_bottom,
		bbox_left + 1, bbox_top, bbox_right - 1, bbox_bottom) == 1)