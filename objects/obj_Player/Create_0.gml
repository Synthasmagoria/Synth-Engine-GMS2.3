///@desc init

run_speed = 3 * g.fps_calculation;
jump_speed = 8.4 * g.fps_calculation;
fall_multiplier = 0.45;

horizontal_normal = new vec2(0,0); // vector facing right
vertical_normal = new vec2(0,0); // vector facing the floor

airjump_speed = 7 * g.fps_calculation;
airjump_number = 1;
airjump_index = 0;

grav_spd_max_default = 9.0 * g.fps_calculation;
grav_spd_max_vine = 2.5 * g.fps_calculation;
grav_spd_max_water = 2.5 * g.fps_calculation;

grav = 0.4 * g.fps_calculation_squared;
grav_dir = 270;
grav_spd = 0.0;
grav_spd_max = grav_spd_max_default;

slope_factor = 1;
on_slope = false;

on_vine = false;
vien_direction = 0;
vine_jumpaway = 15;

situated = false;
facing = g.save_active[SAVE.FACING];
running = true;

player_set_gravity_direction(g.save_active[SAVE.GRAVITY_DIRECTION]);