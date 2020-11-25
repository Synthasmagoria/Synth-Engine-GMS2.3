/*
	These are general utility functions that don't depend on any
	objects to work
*/

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

/// @func draw_sprite_ext_skew(sprite,subimg, x,y, xscale,yscale, rot,alpha, kx,ky, xmult,ymult)
/// https://yal.cc/draw_sprite_ext_skew
/// @arg {real} sprite
/// @arg {real} subimg
/// @arg {real} x
/// @arg {real} y
/// @arg {real} xscale
/// @arg {real} yscale
/// @arg {real} rot
/// @arg {real} alpha
/// @arg {real} kx		How much X skews per each pixel of Y
/// @arg {real} ky		How much Y skews per each pixel of X
/// @arg {real} xmult	Post-skew, post-rotate scale X
/// @arg {real} ymult	Post-skew, post-rotate scale Y
function draw_sprite_ext_skew(sprite, subimg, _x, _y, scalex, scaley, rot, alpha, skew_kx, skew_ky, skew_sx, skew_sy) {
	// compute values that will be reused:
	var rcos = dcos(rot);
	var rsin = -dsin(rot);
	var x1 = -sprite_get_xoffset(sprite) * scalex;
	var x2 = x1 + sprite_get_width(sprite) * scalex;
	var y1 = -sprite_get_yoffset(sprite) * scaley;
	var y2 = y1 + sprite_get_height(sprite) * scaley;

	// compute corner coordinates:
	for (var c = 0; c < 4; c++) {
	    // pick local corner
	    var lx; if (c & 1) lx = x2; else lx = x1;
	    var ly; if (c & 2) ly = y2; else ly = y1;
	    // see https://yal.cc/2d-pivot-points/:
	    var rx = lx * rcos - ly * rsin;
	    var ry = lx * rsin + ly * rcos;
	    // transform and store corner coordinates:
	    global._draw_sprite_ext_skew_x[c] = _x + (rx + ry * skew_kx) * skew_sx;
	    global._draw_sprite_ext_skew_y[c] = _y + (ry + rx * skew_ky) * skew_sy;
	}

	// draw the sprite quad:
	draw_sprite_pos(sprite, subimg,
	    global._draw_sprite_ext_skew_x[0],
	    global._draw_sprite_ext_skew_y[0],
	    global._draw_sprite_ext_skew_x[1],
	    global._draw_sprite_ext_skew_y[1],
	    global._draw_sprite_ext_skew_x[3],
	    global._draw_sprite_ext_skew_y[3],
	    global._draw_sprite_ext_skew_x[2],
	    global._draw_sprite_ext_skew_y[2],
	    alpha
	);
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

///@desc				Convert a time number into a formatted string
///@func				time_to_string(time)
///@arg {real} time		Time value
function time_to_string(time) {
	var sec, mn, hr, str;
	sec = floor(argument[0] % 60);
	mn = floor(argument[0] / 60) % 60;
	hr = floor(argument[0] / 3600);

	if (log10(hr) >= 1)
		str = string(hr) + " : ";
	else
		str = "0" + string(hr) + " : ";
	
	if (log10(mn) >= 1)
		str += string(mn) + " : ";
	else
		str += "0" + string(mn) + " : ";
	
	if (log10(sec) >= 1)
		str += string(sec);
	else
		str += "0" + string(sec);

	return str;
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
	absolute = argument_count > 6 ? argument[7] : false;
	
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
	var destroy = argument_count > 5 ? argument[6] : false;
	var keep = argument_count > 4 ? argument[5] : true;

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
	room_goto(r);
}

///@desc Creates a surface and clears it with the specified color
///@func surface_create_clear(w, h, col)
///@arg {real} w
///@arg {real} h
///@arg {real} col
function surface_create_clear(w, h, col) {
	var s = surface_create(w, h);
	surface_set_target(s);
	draw_clear(col);
	surface_reset_target();
	return s;
}

///@desc Creates a surface and clears it with the specified color and alpha
///@func surface_create_clear_alpha(w, h, col, a)
///@arg {real} w
///@arg {real} h
///@arg {real} col
///@arg {real} a
function surface_create_clear_alpha(w, h, col, a) {
	var s = surface_create(w, h);
	surface_set_target(s);
	draw_clear_alpha(col, a);
	surface_reset_target();
	return s;
}
