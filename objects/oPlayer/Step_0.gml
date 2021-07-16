///@desc Player control

if !stopped
{

if !frozen {
	button_left =		input_check("left")
	button_right =		input_check("right")
	button_jump =		input_check_pressed("jump")
	button_fall =		input_check_released("jump")
	button_jump_hold =	input_check("jump")
	button_suicide =	input_check_pressed("suicide")
	button_fire =		input_check("shoot")
	button_release =	input_check_released("shoot")
}

// Queued speed
velocity.x += queued_speed.x
velocity.y += queued_speed.y
queued_speed.set(0, 0)

#region Run & Facing
if global.settings[$"gravity_control"] == GRAVITY_CONTROL.STANDARD &&
	gravity_direction >= 90 &&
	gravity_direction < 270 {
	_rotControl = -1
} else {
	_rotControl = 1
}

if (button_left)
{
	facing = -1 * _rotControl
	velocity.x -= run_speed * _rotControl
	running = true
}
else if (button_right)
{
	facing = 1 * _rotControl
	velocity.x += run_speed * _rotControl
	running = true
}
else
{
	running = false
}
#endregion

// Set normal fall speed limit
yvelocity_max = yvelocity_limit.normal

#region Water
var _water = instance_place(x, y, oWater)
if (_water)
{
	yvelocity_max = yvelocity_limit.water
	velocity.y = min(velocity.y, yvelocity_limit.water)
	
	if (_water.object_index == oWater1)
		player_refresh_airjumps()
}
#endregion

#region Vines
var _vine = place_meeting(
	x + right.x * vine_check_distance * facing,
	y + right.y * vine_check_distance * facing,
	oVine)
sliding = false

if (_vine)
{
	sliding = true
	vine_direction = facing
	yvelocity_max = yvelocity_limit.vine
	velocity.y = yvelocity_limit.vine
}
else if (vine_direction != 0 && !_vine)
{
	if (button_jump_hold && facing != vine_direction)
	{
		velocity.x = vine_hpush * facing
		velocity.y = -jump_strength
		situated = false
		sfx_play_sound(vinejump_sound)
	}
	
	vine_direction = 0
}
#endregion

// Gravity
velocity.y = approach(velocity.y, yvelocity_max, gravity_pull)

#region Situated
var _mov = right.scale(sign(velocity.x)), _pos = new vec2(x, y)

if gravity_is_diagonal() && place_meeting(x + _mov.x, y + _mov.y, oBlock) {
	_pos.x -= _mov.x
	_pos.y -= _mov.y
}

if (place_meeting(_pos.x + down.x * situated_check_distance, _pos.y + down.y * situated_check_distance, oBlock) && velocity.y > 0.0)
{
	situated = true
	player_refresh_airjumps()
}
else
{
	situated = false
}

delete _mov
delete _pos
#endregion

#region Platforms
var _platform = instance_place(
	x + down.x * max(platform_check_distance, velocity.y),
	y + down.y * max(platform_check_distance, velocity.y),
	oPlatform)

if keyboard_check_pressed(vk_space)
	player_set_gravity_direction(gravity_direction + 45)

if (_platform)
{
	velocity.x += dot_product(right.x, right.y, _platform.hspeed, _platform.vspeed)
	
	with (_platform)
		event_user(0)
	
	var
	_topDist = sprite_origin_to_top(_platform.sprite_index) * abs(_platform.image_yscale),
	_sideDist = sprite_origin_to_right(_platform.sprite_index) * abs(_platform.image_xscale),
	_platCenterTopDist = _topDist + (_sideDist - _topDist) * sin(degtorad(abs(angle_difference(gravity_direction, _platform.image_angle)))),
	_platUp = rotation_matrix.scale(-1).mult_vec2(new vec2(0, -1)),
	_platTop = new vec2(
		_platform.x + _platUp.x * _platCenterTopDist,
		_platform.y + _platUp.y * _platCenterTopDist)
	
	if dot_product(_platUp.x, _platUp.y, x - _platTop.x, y - _platTop.y) <= 0 {
		var _up = down.scale(-1)
		var _relTop = _up.scale(_platTop.sub(get_feet()).dot(_up) + 1)
		var _collision = place_meeting(x + _relTop.x, y + _relTop.y, oBlock)
		
		x += _relTop.x * (!_collision)
		y += _relTop.y * (!_collision)
		
		velocity.y = dot_product(down.x, down.y, _platform.hspeed, _platform.vspeed)
		situated = true
		player_refresh_airjumps()
	}
}
#endregion

#region Jump
if (button_jump)
{
	if (situated || _platform || (_water && _water.object_index == oWater1))
	{
		// Add an additional two pixels when jumping off platform to avoid stuckage on high fps
		if (_platform && situated && !place_meeting(x - down.x * platform_check_distance, y + down.y * platform_check_distance, oBlock)) {
			x -= down.x * platform_check_distance
			y -= down.y * platform_check_distance
		}
		
		velocity.y = -jump_strength
		situated = false
		player_refresh_airjumps()
		sfx_play_sound(jump_sound)
	}
	else if (airjump_index < airjump_number || (_water && object_is_ancestor(_water.object_index, oWater)))
	{
		velocity.y = -airjump_strength
		airjump_index++
		sfx_play_sound(airjump_sound)
	}
}
#endregion

// Fall
if (button_fall && velocity.y < 0)
	velocity.y *= yvelocity_fall

#region Block collisions & movement
hvelocity.set(velocity.x, 0)
vvelocity.set(0, velocity.y)
mult_mat2_vec2(rotation_matrix, hvelocity, hvelocity)
mult_mat2_vec2(rotation_matrix, vvelocity, vvelocity)

if situated && velocity.x != 0 {
	
	var _len = hvelocity.length() + slope_check_extra_distance, _pos
	
	if place_meeting(x + hvelocity.x, y + hvelocity.y, oBlock) {
		// hor, up, down check slope
		_pos = new vec2(x + hvelocity.x - down.x * _len, y + hvelocity.y - down.y * _len)
		if !place_meeting(_pos.x, _pos.y, oBlock) {
			x = _pos.x
			y = _pos.y
			block_align(down)
			velocity.y = 0
		} else {
			do_normal_collision(hvelocity, vvelocity)
		}
	} else {
		// hor, down, up check free
		_pos = new vec2(x + hvelocity.x + down.x * _len, y + hvelocity.y + down.y * _len)
		if place_meeting(_pos.x, _pos.y, oBlock) && !place_meeting(x + hvelocity.x + down.x, y + hvelocity.y + down.y, oBlock) {
			x = _pos.x
			y = _pos.y
			block_protrude(down.scale(-1))
			velocity.y = 0
		} else {
			do_normal_collision(hvelocity, vvelocity)
		}
	}
} else if place_meeting(x + hvelocity.x + vvelocity.x, y + hvelocity.y + vvelocity.y, oBlock) {
	do_normal_collision(hvelocity, vvelocity)
} else {
	x += hvelocity.x + vvelocity.x
	y += hvelocity.y + vvelocity.y
}
#endregion

// Reset horizontal speed
velocity.x = 0

// Death
if (place_meeting(x, y, oKiller) || button_suicide) {
	player_kill(id)
	sfx_play_sound(death_sound)
}

#region Weapon
if (instance_exists(weapon)) {
	var _animationBob = (sprite_index == sprite_idle && floor(image_index) == 1) * image_yscale
	weapon.x = x + hand.x * facing + down.x * _animationBob
	weapon.y = y + hand.y * facing + down.y * _animationBob
	weapon.image_xscale = facing * abs(image_xscale)
	weapon.pointing = facing
	
	if button_release
		weapon.release()
	if button_fire
		player_queue_speed(weapon.fire() * weapon.knockback * -facing * image_xscale, 0)
}
#endregion

#region Sprite
if (animate)
{
	if (situated)
	{
		if (running)
			sprite_index = sprite_run
		else
			sprite_index = sprite_idle
	}
	else if (vine_direction != 0)
	{
		sprite_index = sprite_slide
	}
	else
	{
		if (velocity.y < 0.0)
			sprite_index = sprite_jump
		else
			sprite_index = sprite_fall
	}
}
#endregion

} // stopped