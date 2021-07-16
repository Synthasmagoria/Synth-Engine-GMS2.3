///@func vec2()
///@arg {real}	x
///@arg {real}	y
function vec2(_x, _y) constructor {
	x = _x
	y = _y
	
	static length = function() {return sqrt(sqr(x) + sqr(y))}
	static set = function(_x, _y) {x = _x y = _y}
	static normalize = function() { // Normalizes the vector
		var _len = length()
		if (_len > 0)
			set(x / _len, y / _len)
		else
			set(0.0, 0.0)
	}
	static normalized = function() {
		var _len = length()
		if (_len > 0)
			return new vec2(x / _len, y / _len)
		else
			return new vec2(0, 0)
	}
	static polar = function() {return new vec2(length(), arctan(y / x))}
	static dot = function(v) {return dot_product(x, y, v.x, v.y)}
	static dotn = function(v) {return dot_product_normalized(x, y, v.x, v.y)}
	static add = function(v) {return new vec2(x + v.x, y + v.y)}
	static sub = function(v) {return new vec2(x - v.x, y - v.y)}
	static dist = function(v) {return point_distance(x, y, v.x, v.y)}
	static toString = function() {return "{x = " + string(x) + ", y = " + string(y) + "}"}
}

///@func vec2_from(v)
///@arg {vec2} v
function vec2_from(v) : vec2() constructor {
	x = v.x
	y = v.y
}

///@func vec3()
///@arg x / vec3
///@arg y
///@arg z
function vec3() {
	switch (argument_count) {
		case 0: x = 0 y = 0 z = 0 break
		case 1: x = argument[0].x; y = argument[0].y; z = argument[0].z; break
		case 3: x = argument[0]; y = argument[1]; z = argument[2]; break
	}
	static set = function(_x, _y, _z) {x = _x y = _y z = _z}
}

///@func rect2d(x, y, z, w)
///@arg x
///@arg y
///@arg w
///@arg h
function rect2d(_x, _y, _w, _h) constructor {
	x = _x
	y = _y
	w = _w
	h = _h
	static set = function(_x, _y, _w, _h) {x = _x y = _y w = _w h = _h}
	static toString = function() {
		return
		"{x = " + string(x) +
		", y = " + string(y) + 
		", w = " + string(w) +
		", h = " + string(h) + "}"
	}
}

/*///@func vec3_col(r, g, b)
///@arg r
///@arg g
///@arg b
function vec3_col(_r, _g, _b) constructor {
	r = _r
	g = _g
	b = _b
	static set = function(_r, _g, _b) {r = _r g = _g b = _b}
}

///@func vec4_col(r, g, b, a)
///@arg r
///@arg g
///@arg b
///@arg a
function vec4_col(_r, _g, _b, _a) : vec3_col(_r, _g, _b) constructor {
	a = _a
	static set = function(_r, _g, _b, _a) {r = _r g = _g b = _b a = _a}
}*/