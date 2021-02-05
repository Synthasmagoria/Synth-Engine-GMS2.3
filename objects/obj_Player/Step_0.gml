///@desc Player control

var
_bLeft = keyboard_check(g.button[BUTTON.LEFT]),
_bRight = keyboard_check(g.button[BUTTON.RIGHT]),
_dir = _bRight - _bLeft;

// Run
velocity.x += run_speed * _dir;

// Facing
if (_dir != 0)
{
	facing = _dir;
	running = true;
}
else
{
	running = false;
}

// Gravity
velocity.y = approach(velocity.y, velocity_y_limit, gravity_pull);

// Situated
if (place_meeting(x + down_vector.x, y + down_vector.y, obj_Block) && velocity.y >= 0.0)
{
	situated = true;
	airjump_index = 0;
}
else
{
	situated = false;
}

// Platforms
var _platform = instance_place(x, y, obj_Platform);
if (_platform)
{
	velocity.x += dot_product(right_vector.x, right_vector.y, _platform.hspeed, _platform.vspeed);
}

// Change gravity direction
var _gravityArrow = instance_place(x, y, obj_GravityArrow);
if (_gravityArrow && gravity_direction != _gravityArrow.image_angle)
{
	player_set_gravity_direction(_gravityArrow.image_angle);
	velocity.y = 0.0;
	airjump_index = 0;
}

// Jump
if (keyboard_check_pressed(g.button[BUTTON.JUMP]))
{
	if (situated || _platform)
	{
		velocity.y = -jump_strength;
		situated = false;
		airjump_index = 0;
	}
	else if (airjump_index < airjump_number)
	{
		velocity.y = -airjump_strength;
		airjump_index++;
	}
}

// Fall
if (keyboard_check_released(g.button[BUTTON.JUMP]) && velocity.y < 0.0)
	velocity.y *= velocity_y_fall;

// Block collisions 
right_velocity.set(velocity.x * right_vector.x, velocity.x * right_vector.y);
down_velocity.set(velocity.y * down_vector.x, velocity.y * down_vector.y);

if (place_meeting(
	x + right_velocity.x + down_velocity.x,
	y + right_velocity.y + down_velocity.y,
	obj_Block))
{
	if (place_meeting(x + right_velocity.x, y + right_velocity.y, obj_Block))
	{
		var _horDir = sign(velocity.x);
		while (!place_meeting(x + right_vector.x * _horDir, y + right_vector.y * _horDir, obj_Block))
		{
			x += right_vector.x * _horDir;
			y += right_vector.y * _horDir;
		}
	}
	else
	{
		x += right_velocity.x;
		y += right_velocity.y;
	}
	
	if (place_meeting(x + down_velocity.x, y + down_velocity.y, obj_Block))
	{
		var _verDir = sign(velocity.y);
		while (!place_meeting(x + down_vector.x * _verDir, y + down_vector.y * _verDir, obj_Block))
		{
			x += down_vector.x * _verDir;
			y += down_vector.y * _verDir;
		}
		
		velocity.y = 0.0;
	}
	else
	{
		x += down_velocity.x;
		y += down_velocity.y;
	}
}
else
{
	x += right_velocity.x + down_velocity.x;
	y += right_velocity.y + down_velocity.y;
}

// Reset horizontal speed
velocity.x = 0;