///@desc Spawn instances

time++;

while (floor(time / rate) >= 1) {
	time -= rate;
	
	var instance;
	instance = instance_create_depth(x + xoffset, y + yoffset, depth, object);
	instance.hspeed = hs;
	instance.vspeed = vs;
}