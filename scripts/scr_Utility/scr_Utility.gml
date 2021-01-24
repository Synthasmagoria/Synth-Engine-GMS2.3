/*
	These are general utility functions that don't depend on any
	objects to work
*/

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
	            val += mn - mx - 1;
	        else if (val < mn)
	            val += mx - mn + 1;
	    }
	    return(val);
	}
	else
	{
	    var vOld = val + 1;
	    while (val != vOld)
	    {
	        vOld = val;
	        if (val < mn)
	            val = mx - (mn - val);
	        else if (val > mx)
	            val = mn + (val - mx);
	    }
	    return(val);
	}
}

///@desc Maps a range of values to another range
function map(val, src_min, src_max, dest_min, dest_max) {
	return (val - src_min) / (src_max - src_min) * (dest_max - dest_min) + dest_min;
}

///@desc Move towards point but smooth and without setting speed
///@func lerp_towards_point(xgoal, ygoal, spd)
///@arg {real} xgoal	Point to move towards
///@arg {real} ygoal	
///@arg {real} spd		Movement speed
function lerp_towards_point(xgoal, ygoal, spd) {
	x = lerp(x, xgoal, spd);
	y = lerp(y, ygoal, spd);
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
		return max(val - amount, goal);
	else
		return val;
}

///@desc		Snaps a value to a grid
///@func		snap(val, grid)
///@arg {real}	val
///@arg {real}	grid
function snap(val, grid) {
	return floor(val / grid) * grid;
}

///@desc Randomizes all entries in an array
///@func array_randomize(arr);
///@arg arr
function array_randomize(array) {
	var
	len = array_length(array),
	ind,
	temp;

	for (var i = 0; i < len - 1; i++)
	{
		temp = array[@ i];
		ind = i + irandom(len - i - 2) + 1;
		array[@ i] = array[@ ind];
		array[@ ind] = temp;
	}
}

///@desc				Sets the height of an instance given it has a sprite
///@func				instance_set_height(inst, h)
///@arg {real} inst		Instance to set the height of
///@arg {real} h		New height
function instance_set_height(inst, h) {
	inst.image_yscale = h / sprite_get_height(inst.sprite_index);
}

///@desc				Sets the width of an instance given it has a sprite
///@func				instance_set_width(inst, w)
///@arg {real} inst		Instance to set the width of
///@arg {real} w		New width
function instance_set_width(inst, w) {
	inst.image_xscale = w / sprite_get_width(inst.sprite_index);
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
	absolute = argument_count > 6 ? argument[6] : false;
	
	if (absolute)
	{
		xx = argument[2];
		yy = argument[3];
	}
	else
	{
		xx = argument[1].x;
		yy = argument[1].y;
	
		if (argument_count > 3)
		{
			xx += argument[2];
			yy += argument[3];
		}
	}

	// Destroy/move
	var destroy = argument_count > 5 ? argument[5] : false;
	var keep = argument_count > 4 ? argument[4] : true;

	if (destroy)
	{
		instance_destroy(argument[1]);
	}
	else if (!keep)
	{
		instance_destroy(argument[1]);
		player_spawn(xx, yy);
	}
	else
	{
		argument[1].x = xx;
		argument[1].y = yy;
	}

	// Warp
	room_goto(argument[0]);
}