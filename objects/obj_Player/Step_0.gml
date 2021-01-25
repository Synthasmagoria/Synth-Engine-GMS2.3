///@desc Control & movement

var
_bLeft = keyboard_check(g.button[BUTTON.LEFT]),
_bRight = keyboard_check(g.button[BUTTON.RIGHT]),
_bDir;

// Check if standing on block
if (place_meeting(x + vertical_normal.x, y + vertical_normal.y, obj_Block))
{
	situated = true;
	airjump_index = 0;
}
else
{
	situated = false;
}

var _gravArrow = instance_place(x, y, obj_GravityArrow);
if (_gravArrow)
{
	player_set_gravity_direction(_gravArrow.image_angle);
}

// Speed calculations
if (grav_dir > 0 && grav_dir <= 180)
	_bDir = _bLeft - _bRight;
else
	_bDir = _bRight - _bLeft;

if (_bDir != 0)
{
	facing = _bDir;
	running = true;
}
else
{
	running = false;
}

var _runSpeed = horizontal_normal.mult(_bDir * run_speed);

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
var _gravSpeed = vertical_normal.mult(grav_spd);

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
		_colStep = _runSpeed.unit();
	
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
		_colStep = _gravSpeed.unit();
		
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