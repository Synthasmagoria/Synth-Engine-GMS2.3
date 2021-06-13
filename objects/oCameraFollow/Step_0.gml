///@desc Set camera position

if (active && instance_exists(target))
	camera_set_view_pos(
		camera,
		clamp(target.x - size.x / 2, area.x, area.x + area.w),
		clamp(target.y - size.y / 2, area.y, area.y + area.h))