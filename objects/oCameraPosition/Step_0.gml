///@desc Set cam based on position

if (active)
	camera_set_view_pos(
		camera,
		clamp(x, area.x, area.x + area.w),
		clamp(y, area.y, area.x + area.h))