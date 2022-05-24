///@desc Vars

automatic = false
fire_rate = 0
clip_size = 5
bullet = oBullet
wobble = 0
tip = new vec2(5, -2)
sound = sndPlayerShoot
knockback = 0

// Internal variables
vtip = new vec2(0,0)
htip = new vec2(0,0)
pointing = 1
ready = true
cooldown = 0

persistent = true

set_image_angle = function(angle) {
	image_angle = angle
	var _rotmat = mat2_create_rotation_matrix(angle)
	htip.set(tip.x, 0)
	vtip.set(0, tip.y)
	mult_mat2_vec2(_rotmat, htip, htip)
	mult_mat2_vec2(_rotmat, vtip, vtip)
}

fire = function() {
	if instance_number(bullet) < clip_size && ready && cooldown == 0 {
		sfx_play_sound(sound)
		
		var b = instance_create_depth(
			x + (htip.x * pointing + vtip.x) * abs(image_xscale),
			y + (htip.y * pointing + vtip.y) * abs(image_yscale),
			depth - 1,
			bullet)
		b.speed *= pointing * abs(image_xscale)
		b.direction = image_angle + random_range(-wobble, wobble)
		ready = automatic
		cooldown += fire_rate
		return true
	} else {
		return false
	}
}

release = function() {
	ready = true
}