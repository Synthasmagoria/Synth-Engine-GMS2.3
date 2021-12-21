
enum GRAVITY_CONTROL {
	STANDARD,
	ROTATIONAL,
	__MAX
}

///@func setting_struct()
///@desc struct containing all game settings
function setting_struct() constructor {
	fullscreen = false
	smoothing = false
	scale = 1
	framerate = 60
	music_volume = 0.8
	effect_volume = 1
	vsync = true
	gravity_control = GRAVITY_CONTROL.STANDARD
	gamepad_slot = 0
	input_delay = 0
}

///@func				setting_set(key, value)
///@arg {string} key    The index of the setting to set
///@arg {real} value	The value to set the setting to
///@desc				Sets a game setting and writes it to the configuration file
function setting_set(key, value) {
	switch key {
		case "fullscreen":
		global.settings[$key] = value
		window_set_fullscreen(global.settings[$key])
	
		if (value) {
			window_set_size(GAME_WIDTH, GAME_HEIGHT)
		} else {
			var w = GAME_WIDTH * global.settings[$"scale"], h = GAME_HEIGHT * global.settings[$"scale"]
			window_set_position(display_get_width() / 2 - w / 2, display_get_height() / 2 - h / 2)
		}
		break
	
		case "smoothing":
		global.settings[$key] = value
		break
	
		case "scale":
		global.settings[$key] = value
		var w = GAME_WIDTH * value, h = GAME_HEIGHT * value
		window_set_position(display_get_width() / 2 - w / 2, display_get_height() / 2 - h / 2)
		window_set_size(w, h)
		break
	
		case "framerate":
		global.settings[$key] = value
		global.fps_adjust = FPS_BASE / global.settings[$key]
		global.fps_adjust_squared = sqr(global.fps_adjust)
		game_set_speed(global.settings[$key], gamespeed_fps)
		
		#region Set blood particle variables
		part_type_life(
			global.player_blood_part,
			global.player_blood_part_life / global.fps_adjust,
			global.player_blood_part_life / global.fps_adjust)
		part_type_speed(
			global.player_blood_part,
			0,
			global.player_blood_part_speed  * global.fps_adjust,
			0,
			0)
		part_type_gravity(
			global.player_blood_part,
			global.player_blood_part_gravity * global.fps_adjust_squared,
			270)
		#endregion
		break
	
		case "music_volume":
		global.settings[$key] = clamp(value, 0, 1)
		audio_group_set_gain(audiogroup_default, global.settings[$key], 0)
		break
	
		case "effect_volume":
		global.settings[$key] = clamp(value, 0, 1)
		audio_group_set_gain(audiogroup_sound, global.settings[$key], 0)
		break
	
		case "vsync":
		global.settings[$key] = value ? true : false
		if (global.settings[$key])
			display_set_timing_method(tm_countvsyncs)
		else
			display_set_timing_method(tm_sleep)
		break
	
		case "gravity_control":
		global.settings[$key] = value ? true : false
		break
		
		case "input_delay":
		global.settings[$key] = value
		input_set_delay(value)
		break
	
		default: // exit if non-existant settings key is passed
		exit
		break
	}

	ini_open(CONFIG_FILENAME)
	ini_write_real(CONFIG_SECTION_SETTINGS, key, global.settings[$key])
	ini_close()
}

///@func setting_get(key)
function setting_get(key) {
	return global.settings[$key]
}

///@func setting_write_all()
function setting_write_all() {
	var names = variable_struct_get_names(global.settings)
	ini_open(CONFIG_FILENAME)
	for (var i = variable_struct_names_count(global.settings) - 1; i >= 0; i--)
		ini_write_real(CONFIG_SECTION_SETTINGS, names[i], global.settings[$names[i]])
	ini_close()
}

///@func setting_get_number()
function setting_get_number() {
    return variable_struct_names_count(global.settings)
}

///@func setting_apply_all()
function setting_apply_all() {
    var names = variable_struct_get_names(global.settings)
	for (var i = setting_get_number() - 1; i >= 0; i--)
		setting_set(names[i], global.settings[$names[i]])
}

///@func setting_read_all()
function setting_read_all() {
    var names = variable_struct_get_names(global.settings)
    var defaults = new setting_struct()
	ini_open(CONFIG_FILENAME)
	for (var i = setting_get_number() - 1; i >= 0; i--)
		global.settings[$names[i]] = ini_read_real(CONFIG_SECTION_SETTINGS, names[i], defaults[$names[i]])
	ini_close()
	delete defaults
}

///@func setting_set_defaults()
function setting_set_defaults() {
	delete global.settings
	global.settings = new setting_struct()
	setting_apply_all()
}