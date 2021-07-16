///@desc Player control

// Reset horizontal speed
velocity.x = 0

if !stopped
{

if !frozen {
	button_left =		input_check("left")
	button_right =		input_check("right")
	button_jump =		input_check_pressed("jump")
	button_jump_held =	input_check("jump")
	button_fall =		input_check_released("jump")
	button_suicide =	input_check_pressed("suicide")
	button_fire =		input_check_pressed("shoot")
}

// Queued speed
velocity.x += queued_speed.x
velocity.y += queued_speed.y
queued_speed.set(0, 0)

#region Run & Facing
var _rotControl = (global.setting[SETTING.CONTROL_ROTATIONAL] && vertical_direction == -1) ? -1 : 1

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
vspeed_limit = vspeed_limit_normal

#region Water
var _water = instance_place(x, y, oWater)
if (_water)
{
	vspeed_limit = vspeed_limit_water
	velocity.y = min(velocity.y * vertical_direction, vspeed_limit_water) * vertical_direction
	
	if (_water.object_index == oWater1)
		player_refresh_airjumps()
}
#endregion

#region Vines
var _vine = place_meeting(x + facing, y + facing, oVine)
sliding = false

if (_vine)
{
	sliding = true
	vine_direction = facing
	vspeed_limit = vspeed_limit_vine
	velocity.y = vspeed_limit_vine * vertical_direction
}
else if (vine_direction != 0 && !_vine)
{
	if (button_jump_held && facing != vine_direction)
	{
		velocity.x = vine_hpush * facing
		velocity.y = -jump_strength * vertical_direction
		situated = false
		sfx_play_sound(vinejump_sound)
	}
	
	vine_direction = 0
}
#endregion

// Gravity
velocity.y = approach(velocity.y, vspeed_limit * vertical_direction, gravity_pull)

// Situated
if (place_meeting(x, y + vertical_direction, oBlock) && velocity.y * vertical_direction >= 0.0)
{
	situated = true
	player_refresh_airjumps()
}
else
{
	situated = false
}

#region Platforms
var _platform = instance_place(
	x, y + vertical_direction * (max(platform_check_distance, velocity.y * vertical_direction)), oPlatform)

if (_platform)
{
	velocity.x += _platform.hspeed
	
	with (_platform)
		touch()
	
	var _platTop
	if (abs(angle_difference(image_angle, _platform.image_angle)) != 90)
		_platTop = _platform.y + (_platform.sprite_height / 2 * -vertical_direction)
	else
		_platTop = _platform.y + (_platform.sprite_width / 2 * -vertical_direction)
	
	var
	_platDir = _platform.image_angle + 90 + ((vertical_direction == 1 ? 0 : 180) - _platform.image_angle),
	_abovePlatform = abs(angle_difference(_platDir, point_direction(_platform.x, _platTop, x, y))) < 90,
	_platStandingY =  _platTop - (sprite_get_bbox_bottom(mask_index) - sprite_get_yoffset(mask_index) + 1) * get_yscale()
	
	if (_abovePlatform && !place_meeting(x, _platStandingY, oBlock))
	{
		y = _platStandingY
		velocity.y = _platform.vspeed
		situated = true
		player_refresh_airjumps()
	}
}
#endregion

// Change gravity direction
if (place_meeting(x, y, oGravityArrowDown))
	player_set_gravity(1)
else if (place_meeting(x, y, oGravityArrowUp))
	player_set_gravity(-1)

// Jump
if (button_jump)
{
	if (situated || _platform || (_water && _water.object_index == oWater1))
	{
		// Add an additional two pixels when jumping off platform to avoid stuckage on high fps
		if (_platform && situated && !place_meeting(x, y - vertical_direction * platform_check_distance, oBlock))
			y -= vertical_direction * platform_check_distance
		
		velocity.y = -jump_strength * vertical_direction
		situated = false
		player_refresh_airjumps()
		sfx_play_sound(jump_sound)
	}
	else if (airjump_index < airjump_number || (_water && _water.object_index == oWater2))
	{
		velocity.y = -airjump_strength * vertical_direction
		airjump_index++
		sfx_play_sound(airjump_sound)
	}
}

// Fall
if (button_fall && velocity.y * vertical_direction < 0.0)
	velocity.y *= fall_multiplier

#region Block collisions & movement
if place_meeting(x + velocity.x, y + velocity.y, oBlock) {
	if place_meeting(x + velocity.x, y, oBlock) {
		block_align(new vec2(sign(velocity.x), 0))
	} else {
		x += velocity.x
	}
	
	if place_meeting(x, y + velocity.y, oBlock) {
		block_align(new vec2(0, sign(velocity.y)))
		velocity.y = 0
	} else {
		y += velocity.y
	}
} else {
	x += velocity.x
	y += velocity.y
}
#endregion

if (button_fire) {
	var _bullet = instance_create_depth(
		x + 5 * get_xscale(),
		y - 2 * get_yscale(),
		depth + 1,
		oBullet);
	_bullet.direction = image_angle;
	_bullet.speed = shot_speed * facing;
	audio_play_sound(shot_sound, 0, false);
}

// Death
if (place_meeting(x, y, oKiller) || button_suicide) {
	player_kill(id)
	sfx_play_sound(death_sound)
}

// Pick the right sprite
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
		if (velocity.y * vertical_direction < 0.0)
			sprite_index = sprite_jump
		else
			sprite_index = sprite_fall
	}
}

} // if (stopped)