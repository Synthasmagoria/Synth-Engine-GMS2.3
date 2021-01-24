///@desc Control & movement

var
_bLeft = keyboard_check(g.button[BUTTON.LEFT]),
_bRight = keyboard_check(g.button[BUTTON.RIGHT]),
_bDir;

var _ang = image_angle % 360;
if (_ang <= 90 || _ang >= 270)
	_bDir = _bRight - _bLeft;
else
	_bDir = _bLeft - _bRight;

// Speed calculations
var _runSpeed = new vec2(
	lengthdir_x(run_speed, grav_dir + 90) * _bDir,
	lengthdir_y(run_speed, grav_dir + 90) * _bDir);

var _gravDirStep = new vec2(
	lengthdir_x(1, grav_dir),
	lengthdir_y(1, grav_dir));

// Check if standing on block
if (place_meeting(x + _gravDirStep.x, y + _gravDirStep.y, obj_Block))
{
	situated = true;
	airjump_index = 0;
}
else
{
	situated = false;
}



// Apply gravity
grav_spd = min(grav_spd + grav, grav_spd_max);

if (keyboard_check_pressed(g.button[BUTTON.JUMP]))
{
	if (situated)
	{
		grav_spd = -jump_speed;
		audio_play_sound(snd_PlayerJump, 0, false);
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

// Gravity influenced speed calculations
var _gravSpeed = new vec2(
	lengthdir_x(grav_spd, grav_dir),
	lengthdir_y(grav_spd, grav_dir))

var _totalSpeed = new vec2(
	_gravSpeed.x + _runSpeed.x,
	_gravSpeed.y + _runSpeed.y);

// Block collisions
if (place_meeting(x + _totalSpeed.x, y + _totalSpeed.y, obj_Block))
{
	var _colStep;
	
	// Horizontal collision
	if (_runSpeed.length() != 0 &&
		place_meeting(x + _runSpeed.x, y + _runSpeed.y, obj_Block))
	{
		_colStep = _runSpeed.normalize();
		_colStep.x *= sign(_runSpeed.x);
		_colStep.y *= sign(_runSpeed.y);
	
		show_debug_message(_colStep);
		while (!place_meeting(x + _colStep.x, y + _colStep.y, obj_Block))
		{
			x += _colStep.x;
			y += _colStep.y;
		}
	} 
	else
	{
		x += _runSpeed.x;
		y += _runSpeed.y;
	}
	
	// Vertical collision
	if (_gravSpeed.length() != 0 &&
		place_meeting(x + _gravSpeed.x, y + _gravSpeed.y, obj_Block))
	{
		_colStep = _gravSpeed.normalize();
		_colStep.x *= sign(_gravSpeed.x);
		_colStep.y *= sign(_gravSpeed.y);
		
		show_debug_message(_colStep);
		while (!place_meeting(x + _colStep.x, y + _colStep.y, obj_Block))
		{
			x += _colStep.x;
			y += _colStep.y;
		}
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