///@func						setting_set(setting_index, value)
///@arg {real} setting_index	The index of the setting to set
///@arg {real} value			The value to set the setting to
///@desc						Sets a game setting and writes it to the configuration file

function setting_set(setting_index, value) {
	switch (setting_index) {
		case SETTING.FULLSCREEN:
		g.setting[setting_index] = value;
		window_set_fullscreen(g.setting[setting_index]);
	
		if (value) {
			window_set_size(GAME_WIDTH, GAME_HEIGHT);
			window_set_position(display_get_width() / 2 - GAME_WIDTH / 2, display_get_height() / 2 - GAME_HEIGHT / 2);
		} else {
			var w = GAME_WIDTH * g.setting[SETTING.SCALE], h = GAME_HEIGHT * g.setting[SETTING.SCALE];
			window_set_position(display_get_width() / 2 - w / 2, display_get_height() / 2 - h / 2);
		}
		break;
	
		case SETTING.SMOOTHING:
		g.setting[setting_index] = value;
		break;
	
		case SETTING.SCALE:
		g.setting[setting_index] = value;
		var w = GAME_WIDTH * value, h = GAME_HEIGHT * value;
		window_set_position(display_get_width() / 2 - w / 2, display_get_height() / 2 - h / 2);
		window_set_size(w, h);
		break;
	
		case SETTING.FRAMERATE:
		g.setting[setting_index] = value;
		g.fps_adjust = FPS_MULTIPLIER_CALCULATION;
		g.fps_adjust_squared = FPS_MULTIPLIER_CALCULATION_SQUARED;
		game_set_speed(g.setting[setting_index], gamespeed_fps);
		
		#region Set blood particle variables
		part_type_life(
			g.player_blood_part,
			g.player_blood_part_life / g.fps_adjust,
			g.player_blood_part_life / g.fps_adjust);
		part_type_speed(
			g.player_blood_part,
			0,
			g.player_blood_part_speed  * g.fps_adjust,
			0,
			0);
		part_type_gravity(
			g.player_blood_part,
			g.player_blood_part_gravity * g.fps_adjust_squared,
			270);
		#endregion
		break;
	
		case SETTING.MUSIC:
		g.setting[setting_index] = clamp(value, 0, 1);
		audio_group_set_gain(audiogroup_default, g.setting[setting_index], 0);
		break;
	
		case SETTING.SOUND:
		g.setting[setting_index] = clamp(value, 0, 1);
		audio_group_set_gain(audiogroup_sound, g.setting[setting_index], 0);
		break;
	
		case SETTING.VSYNC:
		g.setting[setting_index] = value ? true : false;
		if (g.setting[setting_index])
			display_set_timing_method(tm_countvsyncs);
		else
			display_set_timing_method(tm_sleep);
		break;
	
		case SETTING.CONTROL_ROTATIONAL:
		g.setting[setting_index] = value ? true : false;
		break;
	
		default: // exit the script is non-existant setting value is passed
		exit;
		break;
	}

	ini_open(CONFIG_FILENAME);
	ini_write_real(CONFIG_SECTION_SETTINGS, setting_index, g.setting[setting_index]);
	ini_close();
}


///@func	setting_set_default()
///@desc	Sets all settings to default and writes them to the configuration file

function setting_set_default() {
	for (var i = 0; i < SETTING.NUMBER; i++)
		setting_set(i, g.setting_default[i]);
}


///@func button_set(button_index, ord)
///@arg {real} button_index		The index of the button mapping to change
///@arg {real} ord				Button unicode value to use
///@desc						Sets a button to be used for an action

function button_set(index, button) {

	// Check if mapping to a world-button
	for (var i = 0; i < BUTTON_WORLD.NUMBER; i++) {
		if (button == g.button_world[i]) {
			exit;
		}
	}

	// Switch if mapping to a button that is already in use
	ini_open(CONFIG_FILENAME);

	for (var i = 0; i < BUTTON.NUMBER; i++) {
		if (button == g.button[i]) {
			g.button[i] = g.button[index];
			ini_write_real(CONFIG_SECTION_BUTTONS, i, g.button[i]);
			break;
		}
	}

	// Map button
	g.button[index] = button;
	ini_write_real(CONFIG_SECTION_BUTTONS, index, g.button[index]);

	ini_close();
}


///@func button_set_default()
///@desc Resets all the button mappings to default

function button_set_default() {
	ini_open(CONFIG_FILENAME);

	for (var i = 0; i < BUTTON.NUMBER; i++) {
		g.button[i] = g.button_default[i];
		ini_write_real(CONFIG_SECTION_BUTTONS, i, g.button[i]);
	}

	ini_close();	
}


///@func				button_to_string(button)
///@arg {real} button	Button unicode value
///@desc				Translates a button unicode to a readable string

function button_to_string(button) {
	var str;

	switch (button) {
		case vk_add: str = "add"; break;
		case vk_alt: str = "alt"; break;
		case vk_backspace: str = "backspace"; break;
		case vk_control: str = "control"; break;
		case vk_decimal: str = "decimal"; break;
		case vk_delete: str = "delete"; break;
		case vk_divide: str = "divide"; break;
		case vk_down: str = "down"; break;
		case vk_end: str = "end"; break;
		case vk_enter: str = "enter"; break;
		case vk_escape: str = "escape"; break;
		case vk_f1: str = "f1"; break;
		case vk_f2: str = "f2"; break;
		case vk_f3: str = "f3"; break;
		case vk_f4: str = "f4"; break;
		case vk_f5: str = "f5"; break;
		case vk_f6: str = "f6"; break;
		case vk_f7: str = "f7"; break;
		case vk_f8: str = "f8"; break;
		case vk_f9: str = "f9"; break;
		case vk_f10: str = "f10"; break;
		case vk_f11: str = "f11"; break;
		case vk_f12: str = "f12"; break;
		case vk_home: str = "home"; break;
		case vk_insert: str = "insert"; break;
		case vk_lalt: str = "left alt"; break;
		case vk_lcontrol: str = "left control"; break;
		case vk_left: str = "left"; break;
		case vk_lshift: str = "left shift"; break;
		case vk_multiply: str = "multiply"; break;
		case vk_numpad0: str = "numpad 0"; break;
		case vk_numpad1: str = "numpad 1"; break;
		case vk_numpad2: str = "numpad 2"; break;
		case vk_numpad3: str = "numpad 3"; break;
		case vk_numpad4: str = "numpad 4"; break;
		case vk_numpad5: str = "numpad 5"; break;
		case vk_numpad6: str = "numpad 6"; break;
		case vk_numpad7: str = "numpad 7"; break;
		case vk_numpad8: str = "numpad 8"; break;
		case vk_numpad9: str = "numpad 9"; break;
		case vk_pagedown: str = "page down"; break;
		case vk_pageup: str = "page up"; break;
		case vk_pause: str = "pause"; break;
		case vk_printscreen: str = "printscreen"; break;
		case vk_ralt: str = "right alt"; break;
		case vk_rcontrol: str = "right control"; break;
		case vk_right: str = "right"; break;
		case vk_rshift: str = "right shift" break;
		case vk_shift: str = "shift"; break;
		case vk_space: str = "space"; break;
		case vk_subtract: str = "subtract"; break;
		case vk_tab: str = "tab"; break;
		case vk_up: str = "up"; break;
	
		case 186: str = ";"; break;
	    case 187: str = "="; break;
	    case 188: str = ","; break;
	    case 189: str = "-"; break;
	    case 190: str = "."; break;
	    case 191: str = "/"; break;
	    case 192: str = "`"; break;
	    case 219: str = "["; break;
	    case 220: str = "\\"; break;
	    case 221: str = "]"; break;
	    case 222: str = "\'"; break;
	
		default: str = chr(argument[0]); break;
	}

	return str;	
}