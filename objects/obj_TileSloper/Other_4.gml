
var
_tilemap = layer_tilemap_get_id(layer_get_id(tilelayer_name)),
_tw = tilemap_get_width(_tilemap),
_th = tilemap_get_height(_tilemap),
_w = tilemap_get_tile_width(_tilemap),
_h = tilemap_get_tile_height(_tilemap);

for (var xx = 0; xx < _tw; xx++)
    for (var yy = 0; yy < _th; yy++)
        switch (tilemap_get(_tilemap, xx, yy))
        {
            case 1: instance_create_depth(xx * _w, yy * _h, 0, obj_Slope_ul); break;
            case 2: instance_create_depth(xx * _w, yy * _h, 0, obj_Slope_ur); break;
            case 3: instance_create_depth(xx * _w, yy * _h, 0, obj_BlockRotatable); break;
            case 4: instance_create_depth(xx * _w, yy * _h, 0, obj_Slope_dl); break;
            case 5: instance_create_depth(xx * _w, yy * _h, 0, obj_Slope_dr); break;
        }