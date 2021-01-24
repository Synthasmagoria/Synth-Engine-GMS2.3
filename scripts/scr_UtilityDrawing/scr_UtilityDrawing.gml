/*
	General utility functions for drawing actions
*/

///@desc Creates a surface and clears it with the specified color
///@func surface_create_clear(w, h, col)
///@arg {real} w
///@arg {real} h
///@arg {real} col
function surface_create_clear(w, h, col) {
	var s = surface_create(w, h);
	surface_set_target(s);
	draw_clear(col);
	surface_reset_target();
	return s;
}

///@desc Creates a surface and clears it with the specified color and alpha
///@func surface_create_clear_alpha(w, h, col, a)
///@arg {real} w
///@arg {real} h
///@arg {real} col
///@arg {real} a
function surface_create_clear_alpha(w, h, col, a) {
	var s = surface_create(w, h);
	surface_set_target(s);
	draw_clear_alpha(col, a);
	surface_reset_target();
	return s;
}

///@desc				Convert a time number into a formatted string
///@func				time_to_string(time)
///@arg {real} time		Time value
function time_to_string(time) {
	var sec, mn, hr, str;
	sec = floor(argument[0] % 60);
	mn = floor(argument[0] / 60) % 60;
	hr = floor(argument[0] / 3600);

	if (log10(hr) >= 1)
		str = string(hr) + " : ";
	else
		str = "0" + string(hr) + " : ";
	
	if (log10(mn) >= 1)
		str += string(mn) + " : ";
	else
		str += "0" + string(mn) + " : ";
	
	if (log10(sec) >= 1)
		str += string(sec);
	else
		str += "0" + string(sec);

	return str;
}

/// @func draw_sprite_ext_skew(sprite,subimg, x,y, xscale,yscale, rot,alpha, kx,ky, xmult,ymult)
/// https://yal.cc/draw_sprite_ext_skew
/// @arg {real} sprite
/// @arg {real} subimg
/// @arg {real} x
/// @arg {real} y
/// @arg {real} xscale
/// @arg {real} yscale
/// @arg {real} rot
/// @arg {real} alpha
/// @arg {real} kx		How much X skews per each pixel of Y
/// @arg {real} ky		How much Y skews per each pixel of X
/// @arg {real} xmult	Post-skew, post-rotate scale X
/// @arg {real} ymult	Post-skew, post-rotate scale Y
function draw_sprite_ext_skew(sprite, subimg, _x, _y, scalex, scaley, rot, alpha, skew_kx, skew_ky, skew_sx, skew_sy) {
	// compute values that will be reused:
	var rcos = dcos(rot);
	var rsin = -dsin(rot);
	var x1 = -sprite_get_xoffset(sprite) * scalex;
	var x2 = x1 + sprite_get_width(sprite) * scalex;
	var y1 = -sprite_get_yoffset(sprite) * scaley;
	var y2 = y1 + sprite_get_height(sprite) * scaley;

	// compute corner coordinates:
	for (var c = 0; c < 4; c++) {
	    // pick local corner
	    var lx; if (c & 1) lx = x2; else lx = x1;
	    var ly; if (c & 2) ly = y2; else ly = y1;
	    // see https://yal.cc/2d-pivot-points/:
	    var rx = lx * rcos - ly * rsin;
	    var ry = lx * rsin + ly * rcos;
	    // transform and store corner coordinates:
	    g._draw_sprite_ext_skew_x[c] = _x + (rx + ry * skew_kx) * skew_sx;
	    g._draw_sprite_ext_skew_y[c] = _y + (ry + rx * skew_ky) * skew_sy;
	}

	// draw the sprite quad:
	draw_sprite_pos(sprite, subimg,
	    g._draw_sprite_ext_skew_x[0],
	    g._draw_sprite_ext_skew_y[0],
	    g._draw_sprite_ext_skew_x[1],
	    g._draw_sprite_ext_skew_y[1],
	    g._draw_sprite_ext_skew_x[3],
	    g._draw_sprite_ext_skew_y[3],
	    g._draw_sprite_ext_skew_x[2],
	    g._draw_sprite_ext_skew_y[2],
	    alpha
	);
}

///@desc Draw text with a colored outline
///@func draw_text_outline(x, y, str, outline_col)
///@arg {real} x
///@arg {real} y
///@arg {string} str
///@arg {real} outline_col
function draw_text_outline(xx, yy, str, outline_col) {
	var c = draw_get_color();
	draw_set_color(outline_col);
	draw_text(xx + 1, yy + 1, str);
	draw_text(xx - 1, yy + 1, str);
	draw_text(xx - 1, yy - 1, str);
	draw_text(xx + 1, yy - 1, str);
	draw_set_color(c);
	draw_text(xx, yy, str);
}