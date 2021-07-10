///@desc Navigate Menu

if (button_changing != -1) {
	
	button_changing_countdown -= f2sec(1)
	
	if button_changing_countdown <= 0 {
		button_changing = -1
	}
	
	if (button_changing == INPUT_DEVICE.KEYBOARD && keyboard_lastkey != 0) {
		button_changing = -1
		
		input_mapping_change(keyboard_mapping[option_index], keyboard_lastkey, INPUT_DEVICE.KEYBOARD)
		get_keyboard_button_strings()
		
		var buttonWidth
		buttonWidth = string_length(keyboard[option_index]) * font_width
		keyboard_width_max = keyboard_width_max < buttonWidth ? buttonWidth : keyboard_width_max
	} else if (button_changing == INPUT_DEVICE.GAMEPAD && gamepad_button_get_any()) {
		button_changing = -1
		
		input_mapping_change(gamepad_mapping[option_index], gamepad_button_get_any(), INPUT_DEVICE.GAMEPAD)
		get_gamepad_button_strings()
		
		var buttonWidth
		buttonWidth = string_length(gamepad[option_index]) * font_width
		gamepad_width_max = gamepad_width_max < buttonWidth ? buttonWidth : gamepad_width_max
	}
} else {
	
	// Navigate menu
	var buttonUp, buttonDown
	buttonUp = input_check_pressed("up")
	buttonDown = input_check_pressed("down")
	
	if (buttonUp || buttonDown) {
		option_index = option_index + buttonDown - buttonUp
		
		if (option_index < 0) {
			option_index = option_number[menu_index] - 1
		} else if (option_index >= option_number[menu_index]) {
			option_index = 0
		}
		
		if (menu_index == MENU_SUB_SAVE) {
			savedata_set_index(option_index)
			savedata_read()
			event_user(0)
		}
	}
	
	if (input_check_pressed("jump")) {
		switch (menu_index) {
			case MENU_SUB_MAIN:
			switch (option_index) {
				case 0: // save select
				menu_index = MENU_SUB_SAVE
				option_index = 0
				savedata_read()
				event_user(0)
				break
				
				case 1: // settings
				menu_index = MENU_SUB_SETTINGS
				option_index = 0
				break
				
				case 2: // keyboard
				menu_index = MENU_SUB_KEYBOARD
				option_index = 0
				break
				
				case 3: // gamepad
				menu_index = MENU_SUB_GAMEPAD
				option_index = 0
				break
				
				case 4: // quit
				game_end()
				break
			}
			break
			
			case MENU_SUB_SAVE:
			savedata_set_index(option_index)
			
			var saveExists = savedata_exists()
			
			menu_index = MENU_SUB_START
			option_index = saveExists ? 0 : 1
			option_color[MENU_SUB_START,0] = saveExists ? c_white : c_gray
			break
			
			case MENU_SUB_START:
			switch (option_index) {
				case 0: // continue
				if (savedata_exists())
					savedata_load()
				break
				
				case 1: // new game
				if (!savedata_exists()) {
					savedata_new_game()
				} else {
					menu_index = MENU_SUB_OVERWRITE
					option_index = 0
				}
				break
			}
			break
			
			case MENU_SUB_OVERWRITE: // overwrite save data?
			switch (option_index) {
				case 0: // no
				menu_index = MENU_SUB_START
				option_index = 0
				break
				
				case 1: // yes
				savedata_new_game()
				break
			}
			break
			
			case MENU_SUB_SETTINGS:
			switch (option_index) {
				case 0: // toggle fullscreen
				setting_set("fullscreen", !setting_get("fullscreen"))
				break
				
				case 1: // toggle smoothing
				setting_set("smoothing", !setting_get("smoothing"))
				break
				
				case 3: // small adjustments to framerate
				setting_set("framerate", min(setting_get("framerate") + 1, fps_max))
				break
				
				case 6: // toggle vsync
				setting_set("vsync", !setting_get("vsync"))
				break
				
				case 7: // gravity rotation preference
				if setting_get("gravity_control") == GRAVITY_CONTROL.ROTATIONAL
					setting_set("gravity_control", GRAVITY_CONTROL.STANDARD)
				else
					setting_set("gravity_control", GRAVITY_CONTROL.ROTATIONAL)
				break
				
				case 9: // restore default settings
				setting_set_defaults()
				break
			}
			
			event_user(1)
			
			break
			
			case MENU_SUB_KEYBOARD:
			switch (option_index) {
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
				case 7:
				case 8:
				case 9:
				button_changing = INPUT_DEVICE.KEYBOARD
				button_changing_countdown = button_changing_length
				keyboard_lastkey = 0
				break
				
				case 10: // restore default keyboard configuration
				input_set_defaults(INPUT_DEVICE.KEYBOARD)
				get_keyboard_button_strings()
				break
			}
			break
			
			case MENU_SUB_GAMEPAD:
			switch (option_index) {
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
				case 7:
				case 8:
				case 9:
				button_changing = INPUT_DEVICE.GAMEPAD
				button_changing_countdown = button_changing_length
				break
				
				case 10: // restore default gamepad configuration
				input_set_defaults(INPUT_DEVICE.GAMEPAD)
				get_gamepad_button_strings()
				break
			}
		}
	}
	
	if (input_check_pressed("shoot")) {
		switch (menu_index) {
			case MENU_SUB_SAVE: // return to main menu from save select
			menu_index = MENU_SUB_MAIN
			option_index = 0
			break
			
			case MENU_SUB_START: // return to save select from game start
			menu_index = MENU_SUB_SAVE
			option_index = savedata_get_index()
			break
			
			case MENU_SUB_OVERWRITE: // return to game start from save overwrite warning
			menu_index = MENU_SUB_START
			option_index = 0
			break
			
			case MENU_SUB_SETTINGS: // return to main menu from settings
			menu_index = MENU_SUB_MAIN
			setting_write_all()
			option_index = 1
			break
			
			case MENU_SUB_KEYBOARD: // return to main menu from keyboard configuration
			menu_index = MENU_SUB_MAIN
			input_mappings_save(INPUT_DEVICE.KEYBOARD)
			option_index = 2
			break
			
			case MENU_SUB_GAMEPAD:
			menu_index = MENU_SUB_MAIN
			input_mappings_save(INPUT_DEVICE.GAMEPAD)
			option_index = 3
			break
		}
	}
	
	var buttonLeft, buttonRight
	buttonRight = input_check_pressed("right")
	buttonLeft = input_check_pressed("left")
	
	if (buttonLeft || buttonRight) {
		if (menu_index == MENU_SUB_SETTINGS) {
			switch (option_index) {
				case 2: // set scale
				setting_set("scale", clamp(setting_get("scale") + (buttonRight - buttonLeft) / 2, 1, setting_scale_max))
				setting[2] = string(setting_get("scale")) + "x"
				break
				
				case 3: // set framerate
				var _newFramerate = clamp(floor((setting_get("framerate") + fps_change*(buttonRight - buttonLeft))/fps_change)*fps_change, fps_min, fps_max)
				setting_set("framerate", _newFramerate)
				setting[3] = string(setting_get("framerate"))
				break

				case 4: // set music volume
				setting_set("music_volume", setting_get("music_volume") + setting_music_change * (buttonRight - buttonLeft))
				setting[4] = string(setting_get("music_volume"))
				break
				
				case 5: // set sound effect volume
				setting_set("effect_volume", setting_get("effect_volume") + setting_sound_change * (buttonRight - buttonLeft))
				setting[5] = string(setting_get("effect_volume"))
				break
				
				case 8:
				setting_set("input_delay", clamp(setting_get("input_delay") + buttonRight - buttonLeft, input_delay_min, input_delay_max))
				setting[8] = string(setting_get("input_delay"))
				break
			}
		} else if (menu_index == MENU_SUB_GAMEPAD) {
			if (option_index == 11) {
				global.gamepad_slot = wrap(global.gamepad_slot + buttonRight - buttonLeft, 0, 11)
				gamepad[11] = string(global.gamepad_slot)
			}
		}
	}
}