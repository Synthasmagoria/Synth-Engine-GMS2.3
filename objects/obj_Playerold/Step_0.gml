///@desc Player control

var
b_left = keyboard_check(global.button[BUTTON.LEFT]) * !frozen,
b_right = keyboard_check(global.button[BUTTON.RIGHT]) * !frozen,
b_jump = keyboard_check_pressed(global.button[BUTTON.JUMP]) * !frozen,
b_jump_hold = keyboard_check(global.button[BUTTON.JUMP]) * !frozen,
b_fall = keyboard_check_released(global.button[BUTTON.JUMP]) * !frozen,
b_shoot = keyboard_check_pressed(global.button[BUTTON.SHOOT]) * !frozen; 

// Reset values
hspeed = 0;
situated = false;

// Horizontal speed & orientation
var orientation = b_right - b_left;

hspeed += hs_run * orientation;
running = orientation != 0;
facing = running ? orientation : facing;

#region Platforms
var platform = collision_rectangle(
	bbox_left,
	bbox_top,
	bbox_right,
	bbox_bottom + max(vspeed, 1) + frac(y),
	obj_Platform,
	false,
	false
);

if (platform) {
	
	with (platform)
		event_user(0);
	
	hspeed += platform.hspeed;
	
	if (y < platform.y && 
		!(bbox_bottom < platform.y && vspeed < platform.vspeed) &&
		!place_meeting(x, platform.y - HITBOX_Y2 - 1, obj_Block)
	) {
		y = platform.y - HITBOX_Y2 - 1;
		vspeed = platform.vspeed;
		situated = true;
	}
}
#endregion

vs_max = vs_max_air;

#region Vines
var
vl = place_meeting(x - 1, y, obj_Vine),
vr = place_meeting(x + 1, y, obj_Vine);
on_vine = vl || vr;

if (on_vine) {
	vs_max = vs_max_vine;
	vspeed = max(vspeed, 0);
	
	if (((vl && orientation == 1) || (vr && orientation == -1)) &&
		!place_meeting(x + vine_jumpaway * orientation, y + vs_jump, obj_Block) &&
		b_jump_hold) {
		hspeed = vine_jumpaway * orientation;
		player_jump(vs_jump);
		audio_play_sound(snd_PlayerVineJump, 0, false);
		on_vine = false;
	}
}
#endregion

#region Water
var water, water_type;
water = instance_place(x, y, obj_Water);

if (water) {
	vs_max = vs_max_water;
	water_type = water.object_index;
	
	// Refresh airjumps when touching water 1
	if (water_type == obj_Water1)
		airjump_index = 0;
} else {
	water_type = -1;
}
#endregion

#region Gravity
if ((vs_gravity_direction == 1 && place_meeting(x, y, obj_GravityArrowUp)) ||
	(vs_gravity_direction == -1 && place_meeting(x, y, obj_GravityArrowDown)))
{
	vs_gravity_direction *= -1;
}
#endregion

// Vertical gravity
vspeed = clamp(vspeed + vs_gravity * vs_gravity_direction, -vs_max, vs_max);

// Check for blocks
situated |= player_situated();

// refresh airjumps
airjump_index *= !situated;

#region Jump
if (b_jump) {
	if (situated || water_type == obj_Water1 || platform) {
		airjump_index = 0;
		player_jump(vs_jump);
		audio_play_sound(snd_PlayerJump, 0, false);
	} else if (airjump_index < airjump_number || water_type == obj_Water2) {
		airjump_index++;
		player_jump(vs_airjump);
		audio_play_sound(snd_PlayerAirjump, 0, false);
	}
}
#endregion

// Fall
if (b_fall && (vspeed < 0))
	vspeed *= vs_fall;

#region Shoot
if (b_shoot) {
	var bullet = instance_create_depth(
		x + 5 * facing * image_xscale,
		y - 2 * vs_gravity_direction * image_yscale,
		depth + 1,
		obj_Bullet);
	bullet.hspeed = facing * hs_bullet;
	audio_play_sound(snd_PlayerShoot, 0, false);
}
#endregion

#region Block
if (place_meeting(x + hspeed, y + vspeed, obj_Block)) {
	while (place_meeting(x + hspeed, y, obj_Block) && hspeed != 0.0) {
		hspeed = approach(hspeed, 0, 1);
	}
	
	x += hspeed;
	hspeed = 0;
	
	if (place_meeting(x, y + vspeed, obj_Block)) {
		do {
			vspeed = approach(vspeed, 0, 1);
		} until (!place_meeting(x, y + vspeed, obj_Block) || vspeed == 0.0);
		y += vspeed;
		vspeed = 0;
	}
}
#endregion

#region Death
if (place_meeting(x + hspeed, y + vspeed, obj_Killer) || keyboard_check_pressed(global.button[BUTTON.SUICIDE])) {
	player_kill(self);
	audio_play_sound(snd_PlayerDeath, 0, false);
}
#endregion