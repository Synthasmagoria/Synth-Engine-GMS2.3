///@descr Spawn instances

time += time_incr;

repeat (floor(time / rate)) {
	
	var instance;
	time -= rate;
	
	for (var i = 0; i < object_number; i++) {
		instance = instance_create_depth(x + xoffset[i], y + yoffset[i], depth, object[i]);
		instance.hspeed = hs[i];
		instance.vspeed = vs[i];
	}
}