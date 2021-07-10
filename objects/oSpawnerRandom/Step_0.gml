///@desc Spawn instances

time += time_incr;

repeat (floor(time / rate)) {
	time -= rate + random(rate_r);
	
	var instance;
	instance = instance_create_depth(x + xoffset, y + yoffset, depth, object);
	instance.hspeed = hs + random(hs_r);
	instance.vspeed = vs + random(vs_r);
}