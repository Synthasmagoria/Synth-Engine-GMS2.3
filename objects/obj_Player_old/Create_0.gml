///@desc Initialize

hs_run = 3 * g.fps_calculation;
hs_bullet = 12 * g.fps_calculation;

vs_max_air = 9.4 * g.fps_calculation;
vs_max_water = 2.4 * g.fps_calculation;
vs_max_vine = 2.4 * g.fps_calculation;
vs_max = vs_max_air;

vs_gravity = 0.4 * g.fps_calculation_squared;
vs_jump = -8.1 * g.fps_calculation;
vs_airjump = -6.6 * g.fps_calculation;
vs_fall = 0.45;

airjump_number = 1;
airjump_index = 0;

on_vine = false;
vine_jumpaway = 15;

frozen = false;
situated = false;
running = false;
facing = 1;