///@desc Put blocks on tiles

var
t = layer_tilemap_get_id(layer_get_id(layer_name)),
w = tilemap_get_width(t),
h = tilemap_get_height(t),
tw = tilemap_get_tile_width(t),
th = tilemap_get_tile_height(t)

for (x = 0; x <= w; x++)
	for (y = 0; y <= h; y++)
		if (tilemap_get(t, x, y))
			instance_create_depth(x * tw, y * th, 0, block)

