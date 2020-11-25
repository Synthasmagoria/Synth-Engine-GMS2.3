///@desc Draw tiled

var sw = sprite_get_width(sprite_index), sh = sprite_get_height(sprite_index);

for (var xx = 0; xx < image_xscale; xx++) {
	for (var yy = 0; yy < image_yscale; yy++) {
		draw_sprite(sprite_index, image_index, x + xx * sw, y + yy * sh);
	}
}
