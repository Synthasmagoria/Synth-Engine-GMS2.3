///@desc Vars

automatic = false
fire_rate = 0
clip_size = 5
bullet = oBullet
wobble = 0
tip = new vec2(5, -2)
sound = sndPlayerShoot
knockback = 0

ready = true
cooldown = 0

persistent = true

fire = function() {
	if instance_number(bullet) < clip_size && ready && cooldown == 0 {
		sfx_play_sound(sound)
		var b = instance_create_depth(
			x + image_xscale * tip.x,
			y + image_yscale * tip.y,
			depth - 1,
			bullet)
		b.speed *= image_xscale
		b.direction += random_range(-wobble, wobble)
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