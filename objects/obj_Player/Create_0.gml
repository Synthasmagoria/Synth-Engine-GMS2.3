///@desc Initialize

run_speed = 3.0 * g.fps_adjust;
jump_strength = 8.4 * g.fps_adjust;
shot_speed = 12 * g.fps_adjust;
vine_hpush = 12;

// Check distances
platform_check_distance = 2;

gravity_pull = 0.4 * g.fps_adjust_squared;
gravity_direction = g.save_active[SAVE.GRAVITY_DIRECTION];

airjump_strength = 7.0 * g.fps_adjust;
airjump_index = 0;
airjump_number = 1;

facing = g.save[SAVE.FACING];
situated = false;
frozen = false;
running = false;
vine_direction = false;

// Accumulative speed variables
velocity_y_limit_normal = 9.0 * g.fps_adjust;
velocity_y_limit_water = 2.4 * g.fps_adjust;
velocity_y_limit_vine = 2.4 * g.fps_adjust;

velocity = new vec2(0.0, 0.0);
velocity_y_limit = velocity_y_limit_normal;
velocity_y_fall = 0.45;
right_velocity = new vec2(0.0, 0.0);
right_vector = new vec2(1.0, 0.0);
down_velocity = new vec2(0.0, 0.0);
down_vector = new vec2(0.0, 1.0);

// Sound variables
jump_sound = snd_PlayerJump;
airjump_sound = snd_PlayerAirjump;
shot_sound = snd_PlayerShoot;
vinejump_sound = snd_PlayerVineJump;
death_sound = snd_PlayerDeath;

player_set_gravity_direction(gravity_direction);