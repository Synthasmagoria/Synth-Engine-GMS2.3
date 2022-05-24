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
	static scale = function(val) {return new vec2(x * val, y * val)}
	static polar = function() {return new vec2(length(), arctan(y / x))}
	static dot = function(v) {return dot_product(x, y, v.x, v.y)}
	static dotn = function(v) {return dot_product_normalized(x, y, v.x, v.y)}
	static add = function(v) {return new vec2(x + v.x, y + v.y)}
	static sub = function(v) {return new vec2(x - v.x, y - v.y)}
	static mult = function(v) {return new vec2(x * v.x, y * v.y)}
	static divi = function(v) {return new vec2(x / v.x, y / v.y)}
	static dist = function(v) {return point_distance(x, y, v.x, v.y)}
	static toString = function() {return "{x = " + string(x) + ", y = " + string(y) + "}"}
}

///@func mat2(x1/v1, y1/v2, [x2], [y2])
///@arg x1/v1
///@arg y1/v2
///@arg x2
///@arg y2
function mat2() constructor {
	
	if argument_count == 2 {
		x = new vec2(argument[0].x, argument[0].y)
		y = new vec2(argument[1].x, argument[1].y)
	} else {
		x = new vec2(argument[0], argument[1])
		y = new vec2(argument[2], argument[3])
	}
	
	static set = function(x1, y1, x2, y2) {
		x.set(x1, y1)
		y.set(x2, y2)
	}
	static mult_vec2 = function(v2) {
		return new vec2(
			v2.x * x.x + v2.y * x.y,
			v2.x * y.x + v2.y * y.y)
	}
	static mult_mat2 = function(m2) {
		return new mat2(
			mult_vec2(m2.x),
			mult_vec2(m2.y))
	}
	static rotation_matrix = function(radians) {
		set(cos(radians), sin(radians), -sin(radians), cos(radians))
	}
	static determinant = function() {
	    return x.x * y.y - x.y * y.x
	}
	static scale = function(val) {
		return new mat2(x.scale(val), y.scale(val))
	}
}

function mat2_create_rotation_matrix(degrees) {
	var _rad = degtorad(degrees)
	return new mat2(cos(_rad), sin(_rad), -sin(_rad), cos(_rad))
}

///@func mult_mat2_vec2(m, v, vout)
///@desc Matrix vector multiplication using a vec2 reference
function mult_mat2_vec2(m, v, vout) {
	vout.set(v.x * m.x.x + v.y * m.x.y,
		  v.x * m.y.x + v.y * m.y.y)
}

///@func mult_mat2_mat2(m1, m2, mout)
function mult_mat2_mat2(m1, m2, mout) {
	mult_mat2_vec2(m1, m2.x, mout.x)
	mult_mat2_vec2(m1, m2.y, mout.y)
}

///@func lerp_mat2(m1, m2, val, mout)
function lerp_mat2(m1, m2, val, mout) {
	mout.set(
        lerp(m1.x.x, m2.x.x, val),
        lerp(m1.x.y, m2.x.y, val),
        lerp(m1.y.x, m2.y.x, val),
        lerp(m1.y.y, m2.y.y, val))
}

///@func vec3(x, y, z)
///@arg x
///@arg y
///@arg z
function vec3(_x, _y, _z) constructor {
    x = _x
    y = _y
    z = _z
    
    static set = function(_x, _y, _z) {x = _x; y = _y; z = _z}
    static length = function() {return sqrt(sqr(x) + sqr(y) + sqr(z))}
    static normalize = function() {
        var _length = length()
        if _length != 0
            set(x / _length, y / _length, z / _length)
    }
}

///@func mat3(x1/v1, y1/v2, z1/v3, x2, y2, z2, x3, y3, z3)
///@arg x1/v1
///@arg y1/v2
///@arg z1/v3
///@arg x2
///@arg y2
///@arg z2
///@arg x3
///@arg y3
///@arg z3
function mat3() constructor {
    if argument_count == 3 {
        x = new vec3(argument[0].x, argument[0].y, argument[0].z)
        y = new vec3(argument[1].x, argument[1].y, argument[1].z)
        z = new vec3(argument[2].x, argument[2].y, argument[2].z)
    } else {
        x = new vec3(argument[0], argument[1], argument[2])
        y = new vec3(argument[3], argument[4], argument[5])
        z = new vec3(argument[6], argument[7], argument[8])
    }
    
    static set = function(x1, y1, z1, x2, y2, z2, x3, y3, z3) {
        x.set(x1, y2, z3); y.set(x1, y2, z3); z.set(x1, y2, z3)
    }
    static set_v3 = function(v1, v2, v3) {
        x.set(v1.x, v1.y, v1.z); y.set(v2.x, v2.y, v2.z); z.set(v3.x, v3.y, v3.z)
    }
}

/*
(   0,  1,  0   )
(  -1,  0,  0   )
(   0,  0,  1   )
*/
///@func mat3_create_rotation_matrix_xy(ang)
function mat3_create_rotation_matrix_xy(ang) {
    return new mat3(
        cos(ang),   sin(ang),   0,
        -sin(ang),  cos(ang),   0,
        0,          0,          1)
}

/*
(   0,  0,  1   )
(   0,  1,  0   )
(  -1,  0,  0   )
*/
///@func mat3_create_rotation_matrix_xz(ang)
function mat3_create_rotation_matrix_xz(ang) {
    return new mat3(
        cos(ang),   0,          sin(ang),
        0,          1,          0,
        -sin(ang),  0,          cos(ang))
}

/*
(   1,  0,  0   )
(   0,  0,  1   )
(   0, -1,  0   )
*/
///@func mat3_create_rotation_matrix_yz(ang)
function mat3_create_rotation_matrix_yz(ang) {
    return new mat3(
        1,          0,          0,
        0,          cos(ang),   sin(ang),
        0,          -sin(ang),  cos(ang))
}

///@func mult_mat3_vec3(m, v, vout)
function mult_mat3_vec3(m, v, vout) {
    vout.set(
        m.x.x * v.x + m.y.x * v.y + m.z.x * v.z,
        m.x.y * v.x + m.y.y * v.y + m.z.y * v.z,
        m.x.z * v.x + m.y.z * v.y + m.z.z * v.z)
}

///@func mult_mat3_mat3(m1, m2, mout)
function mult_mat3_mat3(m1, m2, mout) {
    mult_mat3_vec3(m1, m2.x, mout.x)
    mult_mat3_vec3(m1, m2.y, mout.y)
    mult_mat3_vec3(m1, m2.z, mout.z)
}