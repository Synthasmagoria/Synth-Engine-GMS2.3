///@desc Put blocks on tiles

var
tl = layer_get_id(layer_name),
t = layer_tilemap_get_id(tl),
w = tilemap_get_width(t),
h = tilemap_get_height(t),
tw = tilemap_get_tile_width(t),
th = tilemap_get_tile_height(t),
tid

for (x = 0; x <= w; x++) {
	for (y = 0; y <= h; y++) {
		tid = tilemap_get(t, x, y)
		switch tile_get_index(tid) {
			case 1: instance_create_depth(x * tw, y * th, 0, oBlock) break
			case 2: instance_create_depth(x * tw, y * th, 0, oSlopeLU) break
			case 3: instance_create_depth(x * tw, y * th, 0, oSlopeRU) break
			case 4: instance_create_depth(x * tw, y * th, 0, oSlopeLD) break
			case 5: instance_create_depth(x * tw, y * th, 0, oSlopeRD) break
		}
	}
}

layer_set_visible(tl, false)