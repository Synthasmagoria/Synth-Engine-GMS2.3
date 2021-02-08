///@desc Player control

var
_bLeft = keyboard_check(g.button[BUTTON.LEFT]),
_bRight = keyboard_check(g.button[BUTTON.RIGHT]);

// Run & Facing
if (_bLeft)
{
	facing = -1;
	velocity.x -= run_speed;
	running = true;
}
else if (_bRight)
{
	facing = 1;
	velocity.x += run_speed;
	running = true;
}
else
{
	running = false;
}

/*if (_dir != 0)
{
	facing = _dir;
	running = true;
}
else
{
	running = false;
}*/

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
var _platform = instance_place(
	x + down_vector.x * max(2, velocity.y),
	y + down_vector.y * max(2, velocity.y),
	obj_Platform);

if (_platform)
{
	velocity.x += dot_product(right_vector.x, right_vector.y, _platform.hspeed, _platform.vspeed);
	
	/*var _platTop = new vec2(
       _platform.x + lengthdir_x(_platform.sprite_width / 2, 90 + _platform.image_angle + gravity_direction + 90),
       _platform.y + lengthdir_y(_platform.sprite_height / 2, 90 + _platform.image_angle + gravity_direction + 90));*/
    var _platTop = new vec2(
    	_platform.x - down_vector.x * sprite_width / 2,
    	_platform.y - down_vector.y * sprite_height / 2);
	
	var _abovePlatform = wrap(point_direction(x, y, _platTop.x, _platTop.y), 0, 359) > 180;
	
	if (_abovePlatform)
	{
		if (!place_meeting(x, y, _platform)) // Move down to top of platform
		{
			while (!place_meeting(x + down_vector.x, y + down_vector.y, _platform))
			{
				x += down_vector.x;
				y += down_vector.y;
			}
		}
		else // Move up out of platform
		{
			while (place_meeting(x, y, _platform))
			{
				x -= down_vector.x;
				y -= down_vector.y;
			}
		}
		
		velocity.y = dot_product(down_vector.x, down_vector.y, _platform.hspeed, _platform.vspeed);
		situated = true;
		airjump_index = 0;
	}
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
		audio_play_sound(jump_sound, 0, false);
	}
	else if (airjump_index < airjump_number)
	{
		velocity.y = -airjump_strength;
		airjump_index++;
		audio_play_sound(airjump_sound, 0, false);
	}
}

// Fall
if (keyboard_check_released(g.button[BUTTON.JUMP]) && velocity.y < 0.0)
	velocity.y *= velocity_y_fall;

// Shoot
if (keyboard_check_pressed(g.button[BUTTON.SHOOT]))
{
	var _bullet = instance_create_depth(
		x + 2 * facing * image_xscale,
		y - 5 * facing * image_yscale,
		depth + 1,
		obj_Bullet);
	_bullet.direction = image_angle;
	_bullet.speed = shot_speed;
	audio_play_sound(shot_sound, 0, false);
}

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