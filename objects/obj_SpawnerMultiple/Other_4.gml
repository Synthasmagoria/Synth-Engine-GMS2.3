///@descr Spawn ahead / initialize further

// Create arrays
if (!is_array(object)) {
	object = array_create(object_number, object);
} else {
	object_number = array_length_1d(object);
}

if (!is_array(xoffset)) {xoffset = array_create(object_number, xoffset);}
if (!is_array(yoffset)) {yoffset = array_create(object_number, yoffset);}
if (!is_array(hs)) {hs = array_create(object_number, hs);}
if (!is_array(vs)) {vs = array_create(object_number, vs);}

// Adjust values for fps setting
for (var i = 0; i < object_number; i++) {
	hs[i] *= global.fps_calculation;
	vs[i] *= global.fps_calculation;
}

// Spawn ahead
if (ahead > 0) {
	var orientation, distance, position, instance;
	
	for (var i = 0; i < object_number; i++) {
		orientation = point_direction(0, 0, hs[i], vs[i]);
		distance = point_distance(0, 0, hs[i], vs[i]) * rate / global.fps_calculation;
		position = time / rate * distance;
		
		while (position < ahead) {
			instance = instance_create_depth(
				x + xoffset[i] + lengthdir_x(position, orientation),
				y + yoffset[i] + lengthdir_y(position, orientation),
				depth,
				object[i]
			);
			instance.hspeed = hs[i];
			instance.vspeed = vs[i];
			
			position += distance;
		}
	}
}