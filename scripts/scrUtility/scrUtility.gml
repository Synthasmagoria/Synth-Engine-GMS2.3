/*
	These are general utility functions that don't depend on any
	objects to work
*/

///@func f2sec(f)
///@arg frames
function f2sec(f) {
	return f / global.setting[SETTING.FRAMERATE]	
}

///@func set2f(sec)
///@arg seconds
function sec2f(sec) {
	return sec * global.setting[SETTING.FRAMERATE]
}

///@func camera_get_view(camera)
function camera_get_view(camera) {
	return [
		camera_get_view_x(camera),
		camera_get_view_y(camera),
		camera_get_view_width(camera),
		camera_get_view_height(camera)]
}

///@func block_create(xx, yy, w, h)
///@arg {real} xx
///@arg {real} yy
///@arg {real} w
///@arg {real} h
function block_create(xx, yy, w, h) {
	var b = instance_create_layer(xx, yy, layer, oBlock)
	instance_set_width(b, w)
	instance_set_height(b, h)
	return b
}

///@func move_contact_object(normal, distance, object)
///@arg {real} normal
///@arg {real} distance
///@arg {real} object
///@desc Moves as close as possible to an object in a direction and returns remaining distance
function move_contact_object(normal, distance, object) {
	var step = min(distance, 1)
	while (!place_meeting(x + normal.x * step, y + normal.y * step, object) && distance > 0)
	{
		distance -= step
		x += normal.x * step
		y += normal.y * step
		step = min(distance, 1)
	}
	return max(distance, 0)
}

///@func move_contact_free(normal, distance, object)
///@arg {real} normal
///@arg {real} distance
///@arg {real} object
///@desc Moves out of an object in a direction and returns remaining distance
function move_contact_free(normal, distance, object) {
	var step = min(distance, 1)
	while (place_meeting(x, y, object) && distance > 0)
	{
		distance -= step
		x += normal.x * step
		y += normal.y * step
		step = min(distance, 1)
	}
	return max(distance, 0)
}

///@function wrap(value, min, max)
///@arg {real} value
///@arg {real} min
///@arg {real} max
///@desc Returns the value wrapped, values over or under will be wrapped around
function wrap(val, mn, mx) {
	if (val mod 1 == 0)
	{
	    while (val > mx || val < mn)
	    {
	        if (val > mx)
	            val += mn - mx - 1
	        else if (val < mn)
	            val += mx - mn + 1
	    }
	    return(val)
	}
	else
	{
	    var vOld = val + 1
	    while (val != vOld)
	    {
	        vOld = val
	        if (val < mn)
	            val = mx - (mn - val)
	        else if (val > mx)
	            val = mn + (val - mx)
	    }
	    return(val)
	}
}

///@desc Maps a range of values to another range
function map(val, src_min, src_max, dest_min, dest_max) {
	return (val - src_min) / (src_max - src_min) * (dest_max - dest_min) + dest_min
}

///@desc Move towards point but smooth and without setting speed
///@func lerp_towards_point(xgoal, ygoal, spd)
///@arg {real} xgoal	Point to move towards
///@arg {real} ygoal	
///@arg {real} spd		Movement speed
function lerp_towards_point(xgoal, ygoal, spd) {
	x = lerp(x, xgoal, spd)
	y = lerp(y, ygoal, spd)
}

///@desc Approaches a value
///@func approach(val, goal, amount
///@arg {real} val		Current value
///@arg {real} goal		Value to approach
///@arg {real} amount	Amount to approach by
function approach(val, goal, amount) {
	if (val < goal)
		return min(val + amount, goal)
	else if (val > goal)
		return max(val - amount, goal)
	else
		return val
}

///@desc		Snaps a value to a grid
///@func		snap(val, grid)
///@arg {real}	val
///@arg {real}	grid
function snap(val, grid) {
	return floor(val / grid) * grid
}

///@desc Randomizes all entries in an array
///@func array_randomize(arr)
///@arg arr
function array_randomize(array) {
	var
	len = array_length(array),
	ind,
	temp

	for (var i = 0; i < len - 1; i++)
	{
		temp = array[@ i]
		ind = i + irandom(len - i - 2) + 1
		array[@ i] = array[@ ind]
		array[@ ind] = temp
	}
}

///@desc Finds the longest string in an array of strings
///@func array_find_max_string_width(arr)
///@arg {index} arr
function array_find_max_string_width(arr) {
	var w = 0
	for (var i = array_length(arr) - 1; i >= 0; i--)
		w = max(w, string_width(arr[@i]))
	return w
}

///@desc				Sets the width of an instance given it has a sprite
///@func				instance_set_width(inst, w)
///@arg {real} inst		Instance to set the width of
///@arg {real} w		New width
function instance_set_width(inst, w) {
	inst.image_xscale = w / sprite_get_width(inst.sprite_index)
}

///@desc				Sets the height of an instance given it has a sprite
///@func				instance_set_height(inst, h)
///@arg {real} inst		Instance to set the height of
///@arg {real} h		New height
function instance_set_height(inst, h) {
	inst.image_yscale = h / sprite_get_height(inst.sprite_index)
}

///@desc				Sets the width of an instance
///@func				set_width(w)
///@arg {real} w		New width
function set_width(w) {
	image_xscale = w / sprite_get_width(sprite_index)
}

///@desc				Sets the height of an instance
///@func				set_height(h)
///@arg {real} h		New height
function set_height(h) {
	image_yscale = h / sprite_get_height(sprite_index)
}

///@desc Warps the player
///@func warp(room, inst, [xoff], [yoff], [keep=true], [destroy=false], [abs=false])
///@arg {real} room				Room to warp to
///@arg {real} inst				Instance to warp (must be persistent)
///@arg {real} [xoff]			How much to offset the instance when warping
///@arg {real} [yoff]
///@arg {bool} [keep=true]		If the momentum of the warped instance should be kept or not
///@arg {bool} [destroy=false]	If the warp instance should be destroyed
///@arg {bool} [abs=false]		If xoff and yoff should be used as absolute position when warping
function warp() {
	// Get spawn position
	var 
	xx = 0,
	yy = 0,
	absolute = argument_count > 6 ? argument[6] : false
	
	if (absolute)
	{
		xx = argument[2]
		yy = argument[3]
	}
	else
	{
		xx = argument[1].x
		yy = argument[1].y
	
		if (argument_count > 3)
		{
			xx += argument[2]
			yy += argument[3]
		}
	}

	// Destroy/move
	var destroy = argument_count > 5 ? argument[5] : false
	var keep = argument_count > 4 ? argument[4] : true

	if (destroy)
	{
		instance_destroy(argument[1])
	}
	else if (!keep)
	{
		instance_destroy(argument[1])
		player_spawn(xx, yy)
	}
	else
	{
		argument[1].x = xx
		argument[1].y = yy
	}

	// Warp
	room_goto(argument[0])
}

///@func array_get_max_string_width(arr)
///@desc Gets the maximum string width from an array of strings (array has to consist of strings only)
function array_get_max_string_width(arr) {
	var _maxw = 0, _w
	for (var i = array_length(arr) - 1; i >= 0; i--) {
		_w = string_width(arr[i])
		_maxw = _w > _maxw ? _w : _maxw
	}
	return _maxw
}