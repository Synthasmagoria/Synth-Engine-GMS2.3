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

// Vertical gravity
vspeed = min(vspeed + vs_gravity, vs_max);

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
	player_shoot(facing, hs_bullet, 0, 0);
	audio_play_sound(snd_PlayerShoot, 0, false);
}
#endregion

#region Block
if (place_meeting(x + hspeed, y + vspeed, obj_Block)) {
	
	var block;
	
	block = instance_place(x + hspeed, y, obj_Block);
	if (block)
		player_halign(block);
	else
		x += hspeed;	
	
	hspeed = 0;
	
	block = instance_place(x, y + vspeed, obj_Block);
	if (block) {
		player_valign(block);
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