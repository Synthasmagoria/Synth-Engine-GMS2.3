///@desc Player control

var
_bLeft = keyboard_check(global.button[BUTTON.LEFT]),
_bRight = keyboard_check(global.button[BUTTON.RIGHT]),
_rotControl = (global.setting[SETTING.CONTROL_ROTATIONAL] && vertical_direction == -1) ? -1 : 1;

#region Run & Facing
if (_bLeft)
{
	facing = -1 * _rotControl;
	hspeed -= run_speed * _rotControl;
	running = true;
}
else if (_bRight)
{
	facing = 1 * _rotControl;
	hspeed += run_speed * _rotControl;
	running = true;
}
else
{
	running = false;
}
#endregion

// Set normal fall speed limit
velocity_y_limit = velocity_y_limit_normal;

#region Water
var _water = instance_place(x, y, obj_Water)
if (_water)
{
	velocity_y_limit = velocity_y_limit_water;
	vspeed = min(vspeed, velocity_y_limit_water);
	
	if (_water.object_index == obj_Water1)
		airjump_index = 0;
}
#endregion

#region Vines
var _vine = place_meeting(x + facing, y + facing, obj_Vine);
sliding = false;

if (_vine)
{
	sliding = true;
	vine_direction = facing;
	velocity_y_limit = velocity_y_limit_vine;
	vspeed = velocity_y_limit_vine;
}
else if (vine_direction != 0 && !_vine)
{
	if (keyboard_check(global.button[BUTTON.JUMP]) && facing != vine_direction)
	{
		hspeed = vine_hpush * facing;
		vspeed = -jump_strength * vertical_direction;
		situated = false;
		audio_play_sound(vinejump_sound, 0, false);
	}
	
	vine_direction = 0;
}
#endregion

// Gravity
vspeed = approach(vspeed, velocity_y_limit * vertical_direction, gravity_pull);

// Situated
situated = place_meeting(x, y + vertical_direction, obj_Block) && vspeed * vertical_direction >= 0.0;
airjump_index *= !situated;

#region Platforms
var _platform = instance_place(
	x, y + vertical_direction * (max(platform_check_distance, vspeed * vertical_direction)), obj_Platform);

if (_platform)
{
	hspeed += _platform.hspeed;
	
	var _platTop;
	if (abs(angle_difference(image_angle, _platform.image_angle)) != 90)
		_platTop = _platform.y + (_platform.sprite_height / 2 * -vertical_direction);
	else
		_platTop = _platform.y + (_platform.sprite_height / 2 * -vertical_direction);
	
	var
	_platDir = _platform.image_angle + 90 + ((vertical_direction == 1 ? 0 : 180) - _platform.image_angle),
	_abovePlatform = abs(angle_difference(_platDir, point_direction(_platform.x, _platTop, x, y))) < 90;
	
	if (_abovePlatform)
	{
		vspeed = 0;
		
		if (place_meeting(x, y, obj_Platform))
			do {vspeed -= vertical_direction;} until (!place_meeting(x, y + vspeed, _platform));
		else
			while (!place_meeting(x, y + vspeed + vertical_direction, _platform)) {vspeed += vertical_direction;}
		
		vspeed += _platform.vspeed;
		situated = true;
		airjump_index = 0;
	}
}
#endregion

// Change gravity direction
if (vertical_direction == 1 && place_meeting(x, y, obj_GravityArrowUp))
{
	vertical_direction = -1;
	image_yscale = abs(image_yscale) * -1;
	vspeed = 0.0;
	airjump_index = 0;
}
else if (vertical_direction == -1 && place_meeting(x, y, obj_GravityArrowDown))
{
	vertical_direction = 1;
	image_yscale = abs(image_yscale);
	vspeed = 0.0;
	airjump_index = 0;
}

// Jump
if (keyboard_check_pressed(global.button[BUTTON.JUMP]))
{
	if (situated || _platform || (_water && _water.object_index == obj_Water1))
	{
		// Add an additional two pixels when jumping off platform to avoid stuckage on high fps
		if (_platform && situated && !place_meeting(x, y - vertical_direction * platform_check_distance, obj_Block))
			y -= vertical_direction * platform_check_distance;
		
		vspeed = -jump_strength * vertical_direction;
		situated = false;
		airjump_index = 0;
		audio_play_sound(jump_sound, 0, false);
	}
	else if (airjump_index < airjump_number || (_water && _water.object_index == obj_Water2))
	{
		vspeed = -airjump_strength * vertical_direction;
		airjump_index++;
		audio_play_sound(airjump_sound, 0, false);
	}
}

// Fall
if (keyboard_check_released(global.button[BUTTON.JUMP]) && vspeed * vertical_direction < 0.0)
	vspeed *= velocity_y_fall;

// Shoot
if (keyboard_check_pressed(global.button[BUTTON.SHOOT]))
{
	var _bullet = instance_create_depth(
		x + 5 * facing * image_xscale,
		y - 2 * facing * image_yscale,
		depth + 1,
		obj_Bullet);
	_bullet.direction = image_angle;
	_bullet.speed = shot_speed * facing;
	audio_play_sound(shot_sound, 0, false);
}

#region Block collisions & movement
if (place_meeting(x + hspeed, y + vspeed, obj_Block))
{
	if (place_meeting(x + hspeed, y, obj_Block))
	{
		var _dir = sign(hspeed);
		while (!place_meeting(x + _dir, y, obj_Block)) x += _dir;
	}
	else
	{
		x += hspeed;
	}
	
	if (place_meeting(x, y + vspeed, obj_Block))
	{
		var _dir = sign(vspeed);
		while (!place_meeting(x, y + _dir, obj_Block)) y += _dir;
		vspeed = 0;
	}
}
else
{
	x += hspeed;
}
#endregion

// Reset horizontal speed
hspeed = 0;

// Death
if (place_meeting(x, y, obj_Killer) || keyboard_check_pressed(global.button[BUTTON.SUICIDE])) {
	player_kill(id);
	audio_play_sound(death_sound, 0, false);
}