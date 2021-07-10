///@desc Spawn ahead
var sep, dir, pos, inst, _rate, _hs, _vs
_rate = rate + random(rate_r)
_hs = hs + random(hs_r)
_vs = vs + random(vs_r)
sep = point_distance(x, y, x + _hs * _rate, y + _vs * _rate)
dir = point_direction(x, y, x + hs, y + vs)
pos = offset * sep

while (pos <= ahead) {
	inst = instance_create_depth(
		x + lengthdir_x(pos, dir) + xoffset,
		y + lengthdir_y(pos, dir) + yoffset,
		depth,
		object
	)
	inst.hspeed = hs + random(hs_r)
	inst.vspeed = vs + random(vs_r)
	
	_rate = rate + random(rate_r)
	_hs = hs + random(hs_r)
    _vs = vs + random(vs_r)
    sep = point_distance(x, y, x + _hs * _rate, y + _vs * _rate)
	pos += sep
}