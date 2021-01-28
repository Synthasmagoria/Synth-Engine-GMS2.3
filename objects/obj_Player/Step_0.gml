///@desc Control & movement

// Apply gravity
grav_spd = min(grav_spd + grav, grav_spd_max);

// Buttons
var
_bLeft = keyboard_check(g.button[BUTTON.LEFT]),
_bRight = keyboard_check(g.button[BUTTON.RIGHT]),
_bDir;

var _horVelocity = 0;

// Change rotation
if (keyboard_check_pressed(vk_space))
	player_set_gravity_direction(grav_dir + 45);

// 360 ad
_horVelocity += keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"));

// Check if standing on block
var _blockCheckDistance = player_gravity_is_diagonal() ? 2 : 1;
var _blockCollision = place_meeting(
	x + down_vector.x * _blockCheckDistance,
	y + down_vector.y * _blockCheckDistance,
	obj_Block);

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

/*if (keyboard_check_pressed(ord("D")))
	facing *= -1;*/

/*if (facing == -1)
	image_angle = grav_dir - 315 - 180;
else
	image_angle = grav_dir - 315;*/

//image_xscale = abs(image_xscale) * facing;

_horVelocity += _bDir * run_speed;

// Vines
var _vine = instance_place(x + right_vector.x * facing, y + right_vector.y * facing, obj_Vine)

if (!on_vine && _vine && player_gravity_compatible(_vine))
{
	on_vine = true;
	vine_facing = facing;
	grav_spd_max = grav_spd_max_vine;
	grav_spd = max(0, grav_spd);
}
else if (on_vine && !_vine)
{
	if (facing != vine_facing && keyboard_check(g.button[BUTTON.JUMP]))
	{
		_horVelocity = _bDir * vine_jumpaway;
		grav_spd = -jump_speed;
		audio_play_sound(snd_PlayerVineJump, 0, false);
	}
	
	on_vine = false;
	grav_spd_max = grav_spd_max_default;
}

// Platforms
var _platform = instance_place(
	x + down_vector.x * max(grav_spd, 1),
	y + down_vector.y * max(grav_spd, 1),
	obj_Platform);

if (_platform)
{
	var _platDir = wrap(_platform.image_angle + 270, 0, 359);
	
	// Check if platform rotation is compatible with gravity
	if (_platDir == grav_dir)
	{
		var _platTop = new vec2(
			_platform.x + lengthdir_x(_platform.sprite_width, _platDir - 180) / 2,
			_platform.y + lengthdir_y(_platform.sprite_height, _platDir - 180) / 2);
		
		var
		_playerDir = point_direction(_platTop.x, _platTop.y, x, y),
		_platAngle = wrap(_platform.image_angle, 0, 359) % 180;
		
		// Check is player is above platform
		if (_playerDir > _platAngle && _playerDir < _platAngle + 180)
		{
			var _feetDistance = (sprite_get_bbox_bottom(sprite_index) - sprite_get_xoffset(sprite_index)) * image_yscale;
			
			grav_spd = 0;
			
			if (place_meeting(x, y, _platform))
				do grav_spd--; until (!place_meeting(x + down_vector.x * grav_spd, y + down_vector.y * grav_spd, _platform));
			else
				do grav_spd++; until (place_meeting(x + down_vector.x * grav_spd, y + down_vector.y * grav_spd, _platform));
			
			// Project the platform's movement vector onto the player's down vector
			grav_spd += dot_product(down_vector.x, down_vector.y, _platform.hspeed, _platform.vspeed);
			
			// Refresh airjumps and let the player "stand" on the platform
			situated = true;
			airjump_index = 0;
		}
	}
}

// Jump
if (keyboard_check_pressed(g.button[BUTTON.JUMP]))
{
	if (situated || _platform)
	{
		grav_spd = -jump_speed;
		airjump_index = 0;
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

// Shoot
if (keyboard_check_pressed(g.button[BUTTON.SHOOT]))
{
	var _bullet = instance_create_depth(
		x + 5 * image_xscale * facing,
		y + -2 * image_yscale,
		depth + 1,
		obj_Bullet);
	_bullet.hspeed = right_vector.x * facing * shot_speed;
	_bullet.vspeed = right_vector.y * facing * shot_speed;
}

// Block collisions
if (!player_gravity_is_diagonal())
{
	var _horSpeed = right_vector.mult(_horVelocity);

	var _verSpeed = down_vector.mult(grav_spd);

	var _totalSpeed = new vec2(
		_verSpeed.x + _horSpeed.x,
		_verSpeed.y + _horSpeed.y);
		
	if (place_meeting(x + _totalSpeed.x, y + _totalSpeed.y, obj_Block)) {
		if (place_meeting(x + _horSpeed.x, y + _horSpeed.y, obj_Block)) {
			move_contact_object(right_vector.mult(sign(_horVelocity)), abs(_horVelocity), obj_Block);
		} else {
			x += _horSpeed.x;
			y += _horSpeed.y;
		}
		
		if (place_meeting(x + _verSpeed.x, y + _verSpeed.y, obj_Block)) {
			move_contact_object(down_vector.mult(sign(grav_spd)), abs(grav_spd), obj_Block);
			grav_spd = 0;
		} else {
			x += _verSpeed.x;
			y += _verSpeed.y;
		}
	} else {
		x += _totalSpeed.x;
		y += _totalSpeed.y;
	}
} else {
	// Diagonal horizontal collisions
	var
	_dir = sign(_horVelocity),
	_dist = abs(_horVelocity),
	_step = min(1, _dist);
	
	while (!place_meeting(x + right_vector.x * _dir * (_step + 0.5), y + right_vector.y * _dir * (_step + 0.5), obj_Block) && _dist > 0) {
		x += right_vector.x * _dir;
		y += right_vector.y * _dir;
		_dist -= _step;
		_step = min(1, _dist);
	}
	
	// Diagonal vertical collisions
	_dir = sign(grav_spd);
	_dist = abs(grav_spd);
	_step = min(1, _dist);
	
	while (!place_meeting(x + down_vector.x * _dir, y + down_vector.y * _dir, obj_Block) && _dist > 0) {
		x += down_vector.x * _dir;
		y += down_vector.y * _dir;
		_dist -= _step;
		_step = min(1, _dist);
	}
	
	if (_dist > 0)
		grav_spd = 0;
}