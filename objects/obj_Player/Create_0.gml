///@desc Initialize

run_speed = 3.0 * global.fps_adjust;
jump_strength = 8.1 * global.fps_adjust;
shot_speed = 12 * global.fps_adjust;
vine_hpush = 12;
fall_multiplier = 0.45;

// Check distances
platform_check_distance = 2;

gravity_pull = 0.4 * global.fps_adjust_squared;
gravity_direction = global.save_active[SAVE.GRAVITY_DIRECTION];

airjump_strength = 6.6 * global.fps_adjust;
airjump_index = 0;
airjump_number = 1;

facing = global.save[SAVE.FACING];
situated = false;
frozen = false;
running = false;
vine_direction = false;
vertical_direction = 1;

// Accumulative speed variables
vspeed_limit_normal = 9.0 * global.fps_adjust;
vspeed_limit_water = 2.4 * global.fps_adjust;
vspeed_limit_vine = 2.4 * global.fps_adjust;
vspeed_limit = vspeed_limit_normal;

// Sound variables
jump_sound =		snd_PlayerJump;
airjump_sound =		snd_PlayerAirjump;
shot_sound =		snd_PlayerShoot;
vinejump_sound =	snd_PlayerVineJump;
death_sound =		snd_PlayerDeath;

// Button variables
button_left =		false;
button_right =		false;
button_jump =		false;
button_jump_hold =	false;
button_fall =		false;
button_suicide =	false;
button_shoot =		false;

player_set_gravity(global.save_active[SAVE.GRAVITY_DIRECTION]);