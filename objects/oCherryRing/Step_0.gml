direction += velocity

for (var i = 0; i < cherries; i++) {
	if (instance_exists(cherry[i])) {
		cherry[i].x = x + lengthdir_x(radius, direction + i * angle_separation)
		cherry[i].y = y + lengthdir_y(radius, direction + i * angle_separation)
	}
}