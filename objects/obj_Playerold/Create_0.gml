///@desc Initialize

hs_run = 3 * global.fps_adjust;
hs_bullet = 12 * global.fps_adjust;

vs_max_air = 9.4 * global.fps_adjust;
vs_max_water = 2.4 * global.fps_adjust;
vs_max_vine = 2.4 * global.fps_adjust;
vs_max = vs_max_air;

vs_gravity = 0.4 * global.fps_adjust_squared;
vs_jump = -8.1 * global.fps_adjust;
vs_airjump = -6.6 * global.fps_adjust;
vs_fall = 0.45;
vs_gravity_direction = global.save[SAVE.GRAVITY_DIRECTION];

airjump_number = 1;
airjump_index = 0;

on_vine = false;
vine_jumpaway = 15;

frozen = false;
situated = false;
running = false;
facing = 1;