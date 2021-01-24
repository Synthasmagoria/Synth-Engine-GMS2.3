///@desc init

run_speed = 3 * g.fps_calculation;
jump_speed = 8.4 * g.fps_calculation;
fall_multiplier = 0.45;

airjump_speed = 7 * g.fps_calculation;
airjump_number = 1;
airjump_index = 0;

grav = 0.4 * g.fps_calculation_squared;
grav_dir = 270;
grav_spd = 0.0;
grav_spd_max = 9.0 * g.fps_calculation;

situated = false;