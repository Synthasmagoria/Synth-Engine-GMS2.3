///@desc Player control

var
_bLeft = keyboard_check(g.button[BUTTON.LEFT]),
_bRight = keyboard_check(g.button[BUTTON.RIGHT]);

// Gravity control intuition
var _invertControls = 1;
if (!g.setting[SETTING.CONTROL_ROTATIONAL] && gravity_direction > 0 && gravity_direction < 180)
	_invertControls = -1;

// Run & Facing
if (_bLeft)
{
	facing = -1 * _invertControls;
	velocity.x -= run_speed * _invertControls;
	running = true;
}
else if (_bRight)
{
	facing = 1 * _invertControls;
	velocity.x += run_speed * _invertControls;
	running = true;
}
else
{
	running = false;
}

// Set normal fall speed limit
velocity_y_limit = velocity_y_limit_normal;

// Water
var _water = instance_place(x, y, obj_Water)
if (_water)
{
	velocity_y_limit = velocity_y_limit_water;
	velocity.y = min(velocity.y, velocity_y_limit_water);
	
	if (_water.object_index == obj_Water1)
		airjump_index = 0;
}

// Vines
var _vine = place_meeting(x + right_vector.x * facing, y + right_vector.y * facing, obj_Vine);
sliding = false;

if (_vine)
{
	sliding = true;
	vine_direction = facing;
	velocity_y_limit = velocity_y_limit_vine;
	velocity.y = velocity_y_limit_vine;
}
else if (vine_direction != 0 && !_vine)
{
	if (keyboard_check(g.button[BUTTON.JUMP]) && facing != vine_direction)
	{
		velocity.x = vine_hpush * facing;
		velocity.y = -jump_strength;
		situated = false;
		audio_play_sound(vinejump_sound, 0, false);
	}
	
	vine_direction = 0;
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
var _platform = instance_place(
	x + down_vector.x * max(platform_check_distance, velocity.y),
	y + down_vector.y * max(platform_check_distance, velocity.y),
	obj_Platform);

if (_platform)
{
	velocity.x += dot_product(right_vector.x, right_vector.y, _platform.hspeed, _platform.vspeed);
	
	var _platDir = _platform.image_angle + 90 + (image_angle - _platform.image_angle);
	var _platTop = new vec2(0.0, 0.0);
	
	if (abs(angle_difference(image_angle, _platform.image_angle)) != 90)
    	_platTop.set(
        	_platform.x + lengthdir_x(_platform.sprite_height / 2, _platDir),
        	_platform.y + lengthdir_y(_platform.sprite_height / 2, _platDir));
    else
    {
    	_platTop.set(
        	_platform.x + lengthdir_x(_platform.sprite_width / 2, _platDir),
        	_platform.y + lengthdir_y(_platform.sprite_width / 2, _platDir));
        show_debug_message("it");
    }
	
	// Check if player's origin is above the top of the platform
	var _abovePlatform = abs(angle_difference(_platDir, point_direction(_platTop.x, _platTop.y, x, y))) < 90;
	
	if (_abovePlatform)
	{
		velocity.y = 0;
		
		// Check if feet are inside platform
		var _platCol = place_meeting(x, y, _platform);
		
		if (_platCol) // Move out and to top of platform if inside
		{
			velocity.y--;
			
			while (place_meeting(x + velocity.y * down_vector.x, y + velocity.y * down_vector.y, _platform))
				velocity.y--;
		}
		else // Move down onto top of platform is not inside
		{
			while (!place_meeting(x + (velocity.y + 1) * down_vector.x, y + (velocity.y + 1) * down_vector.y, _platform))
				velocity.y++;
		}
		
		velocity.y += dot_product(down_vector.x, down_vector.y, _platform.hspeed, _platform.vspeed);
		situated = true;
		airjump_index = 0;
	}
	
	delete _platTop;
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
	if (situated || _platform || (_water && _water.object_index == obj_Water1))
	{
		// Add an additional two pixels when jumping off platform to avoid stuckage on high fps
		if (_platform && situated && !place_meeting(
			x - down_vector.x * platform_check_distance,
			y - down_vector.y * platform_check_distance,
			obj_Block))
		{
			x -= down_vector.x * platform_check_distance;
			y -= down_vector.y * platform_check_distance;
		}
		
		velocity.y = -jump_strength;
		situated = false;
		airjump_index = 0;
		audio_play_sound(jump_sound, 0, false);
	}
	else if (airjump_index < airjump_number || (_water && _water.object_index == obj_Water2))
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
		x + 5 * facing * image_xscale,
		y - 2 * facing * image_yscale,
		depth + 1,
		obj_Bullet);
	_bullet.direction = image_angle;
	_bullet.speed = shot_speed * facing;
	audio_play_sound(shot_sound, 0, false);
}

#region Block collisions & movement
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
#endregion

// Reset horizontal speed
velocity.x = 0;

// Death
if (place_meeting(x, y, obj_Killer) || keyboard_check_pressed(g.button[BUTTON.SUICIDE])) {
	player_kill(id);
	audio_play_sound(death_sound, 0, false);
}