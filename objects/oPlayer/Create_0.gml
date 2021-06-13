///@desc Initialize

// Animation
sprite_idle = sPlayerIdle
sprite_run = sPlayerRun
sprite_jump = sPlayerJump
sprite_fall = sPlayerFall
sprite_slide = sPlayerSlide

// Speeds
run_speed = 3.0 * global.fps_adjust
jump_strength = 8.1 * global.fps_adjust
vine_hpush = 12
shot_speed = 15 * global.fps_adjust

// Airjumps
airjump_strength = 6.6 * global.fps_adjust
airjump_index = 0
airjump_number = 1

// Misc control
platform_check_distance = 2
facing = 1
situated = false
frozen = false
stopped = false
running = false
animate = true
vine_direction = false
vertical_direction = 1

// Speed variables
hspeed = 0
vspeed = 0
queued_speed = new vec2(0, 0)

// Accumulative speed variables
gravity_pull = 0.4 * global.fps_adjust_squared
gravity_direction = savedata_get_active("gravity_direction")

vspeed_limit_normal = 9.0 * global.fps_adjust
vspeed_limit_water = 2.4 * global.fps_adjust
vspeed_limit_vine = 2.4 * global.fps_adjust
vspeed_limit = vspeed_limit_normal
fall_multiplier = 0.45

// Sound variables
jump_sound = sndPlayerJump
airjump_sound = sndPlayerAirjump
vinejump_sound = sndPlayerVinejump
death_sound = sndPlayerDeath
shot_sound = sndPlayerShoot

// Button variables
button_fire = false
button_jump = false
button_fall = false
button_left = false
button_right = false
button_suicide = false
button_jump_held = false

remove_input = function() {
	button_fire = false
	button_jump = false
	button_fall = false
	button_left = false
	button_right = false
	button_suicide = false
	button_jump_held = false
}

player_set_gravity(savedata_get_active("gravity_direction"))