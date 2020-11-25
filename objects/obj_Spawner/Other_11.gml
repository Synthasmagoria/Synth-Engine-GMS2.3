///@desc Spawn ahead

var sep, dir, pos, inst;
sep = point_distance(x, y, x + hs * rate, y + vs * rate);
dir = point_direction(x, y, x + hs, y + vs);
pos = offset * sep;

while (pos <= ahead) {
	inst = instance_create_depth(
		x + lengthdir_x(pos, dir) + xoffset,
		y + lengthdir_y(pos, dir) + yoffset,
		depth,
		object
	);
	
	inst.hspeed = hs;
	inst.vspeed = vs;
	
	pos += sep;
}