///@desc Spawn instances

time++

while (floor(time / rate) >= 1) {
	time -= rate
	
	var instance
	instance = instance_create_depth(x + xoffset, y + yoffset, depth, object)
	instance.hspeed = hs
	instance.vspeed = vs
}

adjust = function() {
	if !adjusted {
		adjusted = true

		rate /= global.fps_adjust
		hs *= global.fps_adjust
		vs *= global.fps_adjust
		
		time = rate * offset
	}
}

prespawn = function() {
	var sep, dir, pos, inst
	sep = point_distance(x, y, x + hs * rate, y + vs * rate)
	dir = point_direction(x, y, x + hs, y + vs)
	pos = offset * sep
	
	while (pos <= ahead) {
		inst = instance_create_depth(
			x + lengthdir_x(pos, dir) + xoffset,
			y + lengthdir_y(pos, dir) + yoffset,
			depth,
			object
		)
		
		inst.hspeed = hs
		inst.vspeed = vs
		
		pos += sep
	}
}