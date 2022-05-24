/*
	These are general utility functions that don't depend on any
	objects to work
*/

///@func sprite_origin_to_right(spr_ind)
function sprite_origin_to_right(spr_ind) {
	return sprite_get_bbox_left(spr_ind) - sprite_get_xoffset(spr_ind)
}

///@func sprite_origin_to_left(spr_ind)
function sprite_origin_to_left(spr_ind) {
	return sprite_get_bbox_left(spr_ind) - sprite_get_xoffset(spr_ind)
}

///@func sprite_origin_to_top(spr_ind)
function sprite_origin_to_top(spr_ind) {
	return sprite_get_bbox_top(spr_ind) - sprite_get_yoffset(spr_ind)
}

///@func sprite_origin_to_bottom(spr_ind)
function sprite_origin_to_bottom(spr_ind) {
	return sprite_get_bbox_bottom(spr_ind) - sprite_get_yoffset(spr_ind)
}

///@func instance_struct(id)
///@desc Returns a struct containing all the variables of the instance
///@arg {id} id
function instance_struct(_id) {
	var
	_names = variable_instance_get_names(_id),
	_struct = {}
	
	for (var i = variable_instance_names_count(_id) - 1; i >= 0; i--)
		_struct[$_names[i]] = deep_copy(variable_instance_get(_id, _names[i]))
	
	return _struct
}

/// @function   	deep_copy(ref)
/// @param {T} ref	Thing to deep copy
/// @returns {T}	New array, or new struct, or new instance of the class, anything else (real / string / etc.) will be returned as-is
/// @description	Returns a deep recursive copy of the provided array / struct / constructed struct (stolen from https://github.com/KeeVeeGames)
function deep_copy(ref) {
    var ref_new;
    
    if (is_array(ref)) {
        ref_new = array_create(array_length(ref));
        
        var length = array_length(ref_new);
        
        for (var i = 0; i < length; i++) {
            ref_new[i] = deep_copy(ref[i]);
        }
        
        return ref_new;
    }
    else if (is_struct(ref)) {
        var base = instanceof(ref);
        
        switch (base) {
            case "struct":
            case "weakref":
                ref_new = {};
                break;
                
            default:
                var constr = method(undefined, asset_get_index(base));
                ref_new = new constr();
        }
        
        var names = variable_struct_get_names(ref);
        var length = variable_struct_names_count(ref);
        
        for (var i = 0; i < length; i++) {
            var name = names[i];
            
            variable_struct_set(ref_new, name, deep_copy(variable_struct_get(ref, name)));
        }
        
        return ref_new;
    } else {
        return ref;
    }
}

// GMEdit hint
/// @hint deep_copy(ref:T)->T Returns a deep recursive copy of the provided array / struct / constructed struct

///@func instance_get_center(id)
///@arg {index} id
function instance_get_center(_id) {
	return new vec2(
		_id.bbox_left + (_id.bbox_right - _id.bbox_left) / 2,
		_id.bbox_top + (_id.bbox_bottom - _id.bbox_top) / 2)
}

///@func f2sec(f)
///@arg {real} frames
function f2sec(f) {
	return f / global.settings[$"framerate"]	
}

///@func sec2f(sec)
///@arg {real} seconds
function sec2f(sec) {
	return sec * global.settings[$"framerate"]
}

///@func fps_adjust(val)
///@arg {real} val
function fps_adjust(val) {
	return val * global.fps_adjust
}

///@func fps_inv_adjust(val)
///@arg {real} val
function fps_inv_adjust(val) {
	return val / global.fps_adjust
}

///@func fps_adjust_2(val)
///@arg {real} val
function fps_adjust_2(val) {
	return val * global.fps_adjust_squared
}

///@func fps_inv_adjust_2(val)
///@arg {real} val
function fps_inv_adjust_2(val) {
	return val / global.fps_adjust_squared
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

///@func gamepad_button_get_any()
function gamepad_button_get_any() {
	var length = 16;
	var list = array_create(length)
	
	list[0] = gp_face1;
	list[1] = gp_face2;
	list[2] = gp_face3;
	list[3] = gp_face4;
	list[4] = gp_padu;
	list[5] = gp_padd;
	list[6] = gp_padl;
	list[7] = gp_padr;
	list[8] = gp_stickr;
	list[9] = gp_stickl; 
	list[10] = gp_select;
	list[11] = gp_start;
	list[12] = gp_shoulderr;
	list[13] = gp_shoulderrb;
	list[14] = gp_shoulderl;
	list[15] = gp_shoulderlb;
	
	for (var i = 0; i < length; i++)
	{
	    if (gamepad_button_check_pressed(global.gamepad_slot, list[i]))
	        return list[i];
	}
	
	return -1;
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

///@func tilemap_get_from_layer(layer_name)
///@desc
function tilemap_get_from_layer(layer_name) {
	return layer_tilemap_get_id(layer_get_id(tilemap_layer_name))
}