///@desc Player control

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
hspeed += queued_speed.x
vspeed += queued_speed.y
queued_speed.set(0, 0)

#region Run & Facing
var _rotControl = (global.setting[SETTING.CONTROL_ROTATIONAL] && vertical_direction == -1) ? -1 : 1

if (button_left)
{
	facing = -1 * _rotControl
	hspeed -= run_speed * _rotControl
	running = true
}
else if (button_right)
{
	facing = 1 * _rotControl
	hspeed += run_speed * _rotControl
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
	vspeed = min(vspeed * vertical_direction, vspeed_limit_water) * vertical_direction
	
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
	vspeed = vspeed_limit_vine * vertical_direction
}
else if (vine_direction != 0 && !_vine)
{
	if (button_jump_held && facing != vine_direction)
	{
		hspeed = vine_hpush * facing
		vspeed = -jump_strength * vertical_direction
		situated = false
		sfx_play_sound(vinejump_sound)
	}
	
	vine_direction = 0
}
#endregion

// Gravity
vspeed = approach(vspeed, vspeed_limit * vertical_direction, gravity_pull)

// Situated
if (place_meeting(x, y + vertical_direction, oBlock) && vspeed * vertical_direction >= 0.0)
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
	x, y + vertical_direction * (max(platform_check_distance, vspeed * vertical_direction)), oPlatform)

if (_platform)
{
	hspeed += _platform.hspeed
	
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
		vspeed = _platform.vspeed
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
		
		vspeed = -jump_strength * vertical_direction
		situated = false
		player_refresh_airjumps()
		sfx_play_sound(jump_sound)
	}
	else if (airjump_index < airjump_number || (_water && _water.object_index == oWater2))
	{
		vspeed = -airjump_strength * vertical_direction
		airjump_index++
		sfx_play_sound(airjump_sound)
	}
}

// Fall
if (button_fall && vspeed * vertical_direction < 0.0)
	vspeed *= fall_multiplier

#region Block collisions & movement
if (place_meeting(x + hspeed, y + vspeed, oBlock))
{
	if (place_meeting(x + hspeed, y, oBlock))
	{
		var _dir = sign(hspeed)
		while (!place_meeting(x + _dir, y, oBlock)) x += _dir
	}
	else
	{
		x += hspeed
	}
	
	if (place_meeting(x, y + vspeed, oBlock))
	{
		var _dir = sign(vspeed)
		while (!place_meeting(x, y + _dir, oBlock)) y += _dir
		vspeed = 0
	}
}
else
{
	x += hspeed
}
#endregion

// Reset horizontal speed
hspeed = 0

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
		if (vspeed * vertical_direction < 0.0)
			sprite_index = sprite_jump
		else
			sprite_index = sprite_fall
	}
}

} // if (stopped)