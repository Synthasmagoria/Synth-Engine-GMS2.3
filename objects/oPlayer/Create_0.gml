///@desc Initialize

// Settable variables
run_speed = 3.0 * global.fps_adjust
jump_strength = 8.1 * global.fps_adjust
vine_hpush = 15
vine_jump_strength = 9 * global.fps_adjust
airjump_strength = 6.6 * global.fps_adjust
airjump_index = 0
airjump_number = 1
gravity_pull = 0.4 * global.fps_adjust_squared
gravity_direction_is_rotation = true
yvelocity_limit = new player_yvelocity_limits()
yvelocity_fall = 0.45
hand = new vec2(3, 0)

// Defaults
defaults = instance_struct(id)

#region internal use variables
// Misc control
facing = 1
situated = false
frozen = false
stopped = false
running = false
animate = true
vine_direction = false
on_slope = false

// Collision variables
platform_check_distance = 1				// Added distance when checking for platforms
vine_check_distance = 1					// Added distance when checking for vines
situated_check_distance = 1				// Added distance when determining if on block
slope_check_extra_distance = 2			// Added distance when checking for slopes
right = new vec2(1, 0)
down = new vec2(0, 1)

// Weapon
weapon = noone
weapon_object = -1

// Accumulative speed variables
rotation_matrix = new mat2(1, 0, 0, 1)
hvelocity = new vec2(0, 0)
vvelocity = new vec2(0, 0)
velocity = new vec2(0,0)
queued_speed = new vec2(0,0)
yvelocity_max = yvelocity_limit.normal

// Sound variables
jump_sound = sndPlayerJump
airjump_sound = sndPlayerAirjump
vinejump_sound = sndPlayerVinejump
death_sound = sndPlayerDeath

// Animation
sprite_idle = sPlayerIdle
sprite_run = sPlayerRun
sprite_jump = sPlayerJump
sprite_fall = sPlayerFall
sprite_slide = sPlayerSlide

// Button variables
button_fire = false
button_release = false
button_jump = false
button_jump_hold = false
button_fall = false
button_left = false
button_right = false
button_suicide = false
#endregion

#region local functions
remove_input = function() {
	button_fire = false
	button_release = false
	button_jump = false
	button_jump_hold = false
	button_fall = false
	button_left = false
	button_right = false
	button_suicide = false
}

get_feet = function() {
	var _feet = new vec2(0, sprite_origin_to_bottom(sprite_index) * abs(image_yscale))
	mult_mat2_vec2(rotation_matrix, _feet, _feet)
	_feet.x += x
	_feet.y += y
	return _feet
}

do_normal_collision = function(hv, vv) {
	var _mov = right.scale(sign(velocity.x))
	
	if (_mov.length() > 0 && place_meeting(x + hv.x, y + hv.y, oBlock))
	{
		block_align(_mov)
	}
	else
	{
		x += hv.x
		y += hv.y
	}
	
	_mov = right.scale(sign(facing))
	var _pos = new vec2(x, y)
	
	// Offset vertical check by 1 pixel when hugging a wall diagonally
	if gravity_is_diagonal() && place_meeting(x + _mov.x, y + _mov.y, oBlock) {
		_pos.x -= _mov.x
		_pos.y -= _mov.y
	}
	
	_pos.x += vv.x
	_pos.y += vv.y
	
	_mov = down.scale(sign(velocity.y))
	
	if (_mov.length() > 0 && place_meeting(_pos.x, _pos.y, oBlock))
	{
		block_align(_mov)
		velocity.y = 0
	}
	else
	{
		x += vv.x
		y += vv.y
	}
}

gravity_is_diagonal = function() {
	return frac(gravity_direction / 90) != 0
}
#endregion

player_set_skin(savedata_get_active("skin"))
player_set_weapon(asset_get_index(savedata_get_active("weapon")))
player_set_gravity_direction(savedata_get_active("gravity_direction"))