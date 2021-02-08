///@desc Initialize

run_speed = 3.0 * g.fps_adjust;
jump_strength = 8.4 * g.fps_adjust;
shot_speed = 15 * g.fps_adjust;

gravity_pull = 0.4 * g.fps_adjust_squared;
gravity_direction = g.save_active[SAVE.GRAVITY_DIRECTION];

airjump_strength = 7.0 * g.fps_adjust;
airjump_index = 0;
airjump_number = 1;

facing = g.save[SAVE.FACING];
situated = false;
frozen = false;
running = false;

jump_sound = snd_PlayerJump;
airjump_sound = snd_PlayerAirjump;
shot_sound = snd_PlayerShoot;
vinejump_sound = snd_PlayerVineJump;

// Accumulative speed variables
velocity = new vec2(0.0, 0.0);
velocity_y_limit = 9.0 * g.fps_adjust;
velocity_y_fall = 0.45;
right_velocity = new vec2(0.0, 0.0);
right_vector = new vec2(1.0, 0.0);
down_velocity = new vec2(0.0, 0.0);
down_vector = new vec2(0.0, 1.0);

player_set_gravity_direction(gravity_direction);