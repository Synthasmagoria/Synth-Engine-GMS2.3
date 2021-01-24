///@desc Navigate Menu

if (button_changing) {
	if (keyboard_lastkey != 0) {
		// set a button
		button_changing = false;
		
		button_set(option_index, keyboard_lastkey);
		for (var i = 0; i < BUTTON.NUMBER; i++) {
			button[i] = button_to_string(g.button[i]);
		}
		
		var buttonWidth;
		buttonWidth = string_length(button[option_index]) * font_width;
		button_width_max = button_width_max < buttonWidth ? buttonWidth : button_width_max;
	}
} else {
	
	// Navigate menu
	var buttonUp, buttonDown;
	buttonUp = keyboard_check_pressed(g.button_menu[BUTTON_MENU.UP]);
	buttonDown = keyboard_check_pressed(g.button_menu[BUTTON_MENU.DOWN]);
	
	if (buttonUp || buttonDown) {
		option_index = option_index + buttonDown - buttonUp;
		
		if (option_index < 0) {
			option_index = option_number[menu_index] - 1;
		} else if (option_index >= option_number[menu_index]) {
			option_index = 0;
		}
		
		if (menu_index == menu_sub_save) {
			savedata_set_index(option_index);
			savedata_read();
			event_user(0);
		}
	}
	
	if (keyboard_check_pressed(g.button_menu[BUTTON_MENU.ACCEPT])) {
		switch (menu_index) {
			case menu_sub_main:
			switch (option_index) {
				case 0: // play
				menu_index = 1;
				option_index = 0;
				savedata_read();
				event_user(0);
				break;
				
				case 1: // settings
				menu_index = 4;
				option_index = 0;
				break;
				
				case 2: // buttons
				menu_index = 5;
				option_index = 0;
				break;
				
				case 3: // quit
				game_end();
				break;
			}
			break;
			
			case menu_sub_save:
			savedata_set_index(option_index);
			
			var saveExists = savedata_exists();
			
			menu_index = 2;
			option_index = saveExists ? 0 : 1;
			option_color[2,0] = saveExists ? c_white : c_gray;
			break;
			
			case menu_sub_start:
			switch (option_index) {
				case 0: // continue
				if (savedata_exists())
					savedata_load();
				break;
				
				case 1: // new game
				if (!savedata_exists()) {
					savedata_new_game();
				} else {
					menu_index = 3;
					option_index = 0;
				}
				break;
			}
			break;
			
			case menu_sub_overwrite: // 4overwrite save data?
			switch (option_index) {
				case 0: // no
				menu_index = 2;
				option_index = 0;
				break;
				
				case 1: // yes
				savedata_new_game();
				break;
			}
			break;
			
			case menu_sub_settings:
			switch (option_index) {
				case 0: // toggle fullscreen
				setting_set(SETTING.FULLSCREEN, !g.setting[SETTING.FULLSCREEN]);
				break;
				
				case 1: // toggle smoothing
				setting_set(SETTING.SMOOTHING, !g.setting[SETTING.SMOOTHING]);
				break;
				
				case 6: // toggle vsync
				setting_set(SETTING.VSYNC, !g.setting[SETTING.VSYNC]);
				break;
				
				case 7: // restore default settings
				setting_set_default();
				break;
			}
			
			event_user(1);
			
			break;
			
			case menu_sub_buttons:
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
				button_changing = true;
				keyboard_lastkey = 0;
				break;
				
				case BUTTON.NUMBER: // restore default button configuration
				button_set_default();
				for (var i = 0; i < BUTTON.NUMBER; i++) {
					button[i] = button_to_string(g.button[i]);
				}
				break;
			}
			break;
		}
	}
	
	if (keyboard_check_pressed(g.button_menu[BUTTON_MENU.DECLINE])) {
		switch (menu_index) {
			case menu_sub_save: // return to main menu from save select
			menu_index = 0;
			option_index = 0;
			break;
			
			case menu_sub_start: // return to save select from game start
			menu_index = 1;
			option_index = savedata_get_index();
			break;
			
			case menu_sub_overwrite: // return to game start from save overwrite warning
			menu_index = 2;
			option_index = 0;
			break;
			
			case menu_sub_settings: // return to main menu from settings
			menu_index = 0;
			option_index = 1;
			break;
			
			case menu_sub_buttons: // return to main menu from button configuration
			menu_index = 0;
			option_index = 2;
			break;
		}
	}
	
	var buttonLeft, buttonRight;
	buttonRight = keyboard_check_pressed(g.button_menu[BUTTON_MENU.RIGHT]);
	buttonLeft = keyboard_check_pressed(g.button_menu[BUTTON_MENU.LEFT]);
	
	if (buttonLeft || buttonRight) {
		if (menu_index == menu_sub_settings) {
			switch (option_index) {
				case 2: // set scale
				setting_set(SETTING.SCALE, clamp(g.setting[SETTING.SCALE] + (buttonRight - buttonLeft) / 2, 1, setting_scale_max));
				setting[SETTING.SCALE] = string(g.setting[SETTING.SCALE]) + "x";
				break;
				
				case 3: // set framerate
				setting_framerate_index = clamp(setting_framerate_index + buttonRight - buttonLeft, 0, setting_framerate_number - 1);
				setting_set(SETTING.FRAMERATE, setting_framerate[setting_framerate_index]);
				setting[SETTING.FRAMERATE] = string(g.setting[SETTING.FRAMERATE]);
				break;

				case 4: // set music volume
				setting_set(SETTING.MUSIC, g.setting[SETTING.MUSIC] + setting_music_change * (buttonRight - buttonLeft));
				setting[SETTING.MUSIC] = string(g.setting[SETTING.MUSIC]);
				break;
				
				case 5: // set sound effect volume
				setting_set(SETTING.SOUND, g.setting[SETTING.SOUND] + setting_sound_change * (buttonRight - buttonLeft));
				setting[SETTING.SOUND] = string(g.setting[SETTING.SOUND]);
				break;
			}
		}
	}
}