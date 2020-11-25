///@desc Initialize

hs_run = 3 * global.fps_calculation;
hs_bullet = 12 * global.fps_calculation;

vs_max = 9.4 * global.fps_calculation;
vs_gravity = 0.4 * global.fps_calculation_squared;
vs_jump = -8.1 * global.fps_calculation;
vs_djump = -6.6 * global.fps_calculation;
vs_fall = 0.45;
vs_water = 2.4 * global.fps_calculation;

djump_number = 1;
djump_index = 0;

frozen = false;
situated = false;
running = false;
facing = 1;