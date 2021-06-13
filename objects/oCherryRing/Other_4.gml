if !initialized {
	cherry = array_create(cherries)
	angle_separation = 360 / cherries
	
	for (var i = 0; i < cherries; i++)
		cherry[i] = instance_create_layer(
			x + lengthdir_x(radius, i * angle_separation),
			y + lengthdir_y(radius, i * angle_separation),
			layer,
			object);
}