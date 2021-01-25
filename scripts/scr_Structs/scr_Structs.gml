///@func vec2(x, y)
///@arg {real}	x
///@arg {real}	y
function vec2(_x, _y) constructor {
	x = _x;
	y = _y;
	static length = function() {return sqrt(sqr(x) + sqr(y));};
	static set = function(_x, _y) {x = _x; y = _y;};
	static normalize = function() { // Normalizes the vector
		var _len = length();
		if (_len > 0)
			set(x / _len, y / _len)
		else
			set(0.0, 0.0);
	}
	static unit = function() { // Like normalize, returns the normalized vector
		var _len = length();
		if (_len > 0) {
			return new vec2(x / _len, y / _len);
		}
	}
	static mult = function(val) {return new vec2(x * val, y * val);}
}

///@func vec3(x, y, z)
///@arg x
///@arg y
///@arg z
function vec3(_x, _y, _z) : vec2(_x, _y) constructor {
	z = _z;
	static set = function(_x, _y, _z) {x = _x; y = _y; z = _z;};
}

///@func rect2d(x, y, z, w)
///@arg x
///@arg y
///@arg w
///@arg h
function rect2d(_x, _y, _w, _h) : vec2(_x, _y) constructor {
	w = _w;
	h = _h;
	static set = function(_x, _y, _w, _h) {x = _x; y = _y; w = _w; h = _h;};
	static toString = function() {
		return
		"{x : " + string(x) +
		", y : " + string(y) + 
		", w : " + string(w) +
		", h : " + string(h) + "}";
	};
}

/*///@func vec3_col(r, g, b)
///@arg r
///@arg g
///@arg b
function vec3_col(_r, _g, _b) constructor {
	r = _r;
	g = _g;
	b = _b;
	static set = function(_r, _g, _b) {r = _r; g = _g; b = _b;};
}

///@func vec4_col(r, g, b, a)
///@arg r
///@arg g
///@arg b
///@arg a
function vec4_col(_r, _g, _b, _a) : vec3_col(_r, _g, _b) constructor {
	a = _a;
	static set = function(_r, _g, _b, _a) {r = _r; g = _g; b = _b; a = _a;};
}*/