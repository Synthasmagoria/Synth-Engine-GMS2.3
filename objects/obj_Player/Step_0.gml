///@desc Control & movement

var
_bLeft = keyboard_check(g.button[BUTTON.LEFT]),
_bRight = keyboard_check(g.button[BUTTON.RIGHT]),
_bDir;

// Check if standing on block
var _blockCollision = place_meeting(x + vertical_normal.x, y + vertical_normal.y, obj_Block);
on_slope = place_meeting(x + vertical_normal.x, y + vertical_normal.y, obj_Slope);

if (_blockCollision)
{
	situated = true;
	airjump_index = 0;
	grav_spd = 0;
}
else
{
	situated = false;
}

var _gravArrow = instance_place(x, y, obj_GravityArrow);
if (_gravArrow && grav_dir != _gravArrow.image_angle)
{
	player_set_gravity_direction(_gravArrow.image_angle);
	grav_spd = 0;
	airjump_index = 0;
}

// Make controlling gravity a bit more intuitive
if (grav_dir > 0 && grav_dir <= 180)
	_bDir = _bLeft - _bRight;
else
	_bDir = _bRight - _bLeft;

// 
if (_bDir != 0)
{
	facing = _bDir;
	running = true;
}
else
{
	running = false;
}

var _horVelocity = _bDir * run_speed;

// Vines
if (!on_vine)
{
	var _vine = instance_place(x + horizontal_normal.x * facing, y + horizontal_normal.y * facing, obj_Vine)
	
	if (_vine && (grav_dir % 180) == (_vine.image_angle % 180))
	{
		on_vine = true;
		vine_direction = facing;
		grav_spd_max = grav_spd_max_vine;
		grav_spd = max(0, grav_spd);
	}
}
else if (on_vine && !place_meeting(x + horizontal_normal.x * _bDir, y + horizontal_normal.y * _bDir, obj_Vine))
{
	if (keyboard_check(g.button[BUTTON.JUMP]) && _bDir != vine_direction)
	{
		_horVelocity = _bDir * vine_jumpaway;
		grav_spd = -jump_speed;
		audio_play_sound(snd_PlayerVineJump, 0, false);
	}
	
	on_vine = false;
	grav_spd_max = grav_spd_max_default;
}

// Apply gravity
grav_spd = min(grav_spd + grav, grav_spd_max);

if (keyboard_check_pressed(g.button[BUTTON.JUMP]))
{
	if (situated)
	{
		grav_spd = -jump_speed;
		audio_play_sound(snd_PlayerJump, 0, false);
		situated = false;
	}
	else if (airjump_index < airjump_number)
	{
		grav_spd = -airjump_speed;
		airjump_index++;
		audio_play_sound(snd_PlayerAirjump, 0, false);
	}
}

if (keyboard_check_released(g.button[BUTTON.JUMP]) && grav_spd < 0.0)
	grav_spd *= fall_multiplier;

// Speed calculations
var _horSpeed = horizontal_normal.mult(_horVelocity);

var _gravSpeed = vertical_normal.mult(grav_spd);

var _totalSpeed = new vec2(
	_gravSpeed.x + _horSpeed.x,
	_gravSpeed.y + _horSpeed.y);

// Block collisions
if (place_meeting(x + _totalSpeed.x, y + _totalSpeed.y, obj_Block))
{
	if (place_meeting(x + _horSpeed.x, y + _horSpeed.y, obj_Block))
	{
		move_contact_object(horizontal_normal.mult(_bDir), run_speed, obj_Block);
	}
	else
	{
		x += _horSpeed.x;
		y += _horSpeed.y;
	}
	
	if (place_meeting(x + _gravSpeed.x, y + _gravSpeed.y, obj_Block))
	{
		move_contact_object(vertical_normal.mult(sign(grav_spd)), abs(grav_spd), obj_Block);
		grav_spd = 0;
	}
	else
	{
		x += _gravSpeed.x;
		y += _gravSpeed.y;
	}
}
else
{
	x += _totalSpeed.x;
	y += _totalSpeed.y;
}