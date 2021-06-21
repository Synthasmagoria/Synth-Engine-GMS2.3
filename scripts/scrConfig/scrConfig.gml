///@func						config_setting_set(setting_index, value)
///@arg {real} setting_index	The index of the setting to set
///@arg {real} value			The value to set the setting to
///@desc						Sets a game setting and writes it to the configuration file
function config_setting_set(setting_index, value) {
	switch (setting_index) {
		case SETTING.FULLSCREEN:
		global.setting[setting_index] = value
		window_set_fullscreen(global.setting[setting_index])
	
		if (value) {
			window_set_size(GAME_WIDTH, GAME_HEIGHT)
			window_set_position(display_get_width() / 2 - GAME_WIDTH / 2, display_get_height() / 2 - GAME_HEIGHT / 2)
		} else {
			var w = GAME_WIDTH * global.setting[SETTING.SCALE], h = GAME_HEIGHT * global.setting[SETTING.SCALE]
			window_set_position(display_get_width() / 2 - w / 2, display_get_height() / 2 - h / 2)
		}
		break
	
		case SETTING.SMOOTHING:
		global.setting[setting_index] = value
		break
	
		case SETTING.SCALE:
		global.setting[setting_index] = value
		var w = GAME_WIDTH * value, h = GAME_HEIGHT * value
		window_set_position(display_get_width() / 2 - w / 2, display_get_height() / 2 - h / 2)
		window_set_size(w, h)
		break
	
		case SETTING.FRAMERATE:
		global.setting[setting_index] = value
		global.fps_adjust = FPS_BASE / global.setting[SETTING.FRAMERATE]
		global.fps_adjust_squared = sqr(global.fps_adjust)
		game_set_speed(global.setting[setting_index], gamespeed_fps)
		
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
	
		case SETTING.MUSIC:
		global.setting[setting_index] = clamp(value, 0, 1)
		audio_group_set_gain(audiogroup_default, global.setting[setting_index], 0)
		break
	
		case SETTING.SOUND:
		global.setting[setting_index] = clamp(value, 0, 1)
		audio_group_set_gain(audiogroup_sound, global.setting[setting_index], 0)
		break
	
		case SETTING.VSYNC:
		global.setting[setting_index] = value ? true : false
		if (global.setting[setting_index])
			display_set_timing_method(tm_countvsyncs)
		else
			display_set_timing_method(tm_sleep)
		break
	
		case SETTING.CONTROL_ROTATIONAL:
		global.setting[setting_index] = value ? true : false
		break
	
		case SETTING.INPUT_DELAY:
		global.setting[setting_index] = value
		input_set_delay(value)
		break
	
		default: // exit the script is non-existant setting value is passed
		exit
		break
	}

	ini_open(CONFIG_FILENAME)
	ini_write_real(CONFIG_SECTION_SETTINGS, setting_index, global.setting[setting_index])
	ini_close()
}


///@func	config_setting_set_default()
///@desc	Sets all settings to default and writes them to the configuration file
function config_setting_set_default() {
	for (var i = 0; i < SETTING.NUMBER; i++)
		config_setting_set(i, global.setting_default[i])
}

///@desc Checks if a section in the config exists
///@func config_section_exists(section)
///@arg {string} section
function config_section_exists(section) {
	var val = false
	if file_exists(CONFIG_FILENAME) {
		ini_open(CONFIG_FILENAME)
		val = ini_section_exists(section)
		ini_close()
	}
	return val
}