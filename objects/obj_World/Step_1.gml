///@desc Window/Game control

// Debug
if (DEBUG && global.game_playing) {
	// Toggle nodeath
	if (keyboard_check_pressed(global.debug_nodeath_button)) {
		global.debug_nodeath = !global.debug_nodeath;
		audio_play_sound(snd_BlockChange, 0, false);
	}
	
	// Save anywhere
	if (keyboard_check_pressed(global.debug_save_button) && instance_exists(obj_Player)) {
		player_save();
		audio_play_sound(snd_BlockChange, 0, false);
	}
	
	// Place the player at mouse
	if (mouse_check_button_pressed(mb_left)) {
		if (!instance_exists(obj_Player))
			player_respawn();
		
		obj_Player.x = mouse_x;
		obj_Player.y = mouse_y;
	}
	
	// Go to any room
	if (keyboard_check_pressed(global.debug_warp_button)) {
		var r = asset_get_index(get_string("Go to room: ", ""));
		if (room_exists(r))
			room_goto(r);
	}
}

// Game control
if (global.game_playing) {
	
	// Pause
	if (keyboard_check_pressed(global.button[BUTTON.PAUSE])) {
		global.game_paused = !global.game_paused;
		
		if (global.game_paused) {
			instance_deactivate_all(true);
		} else {
			instance_activate_all();
		}
		
		if (surface_exists(pause_surface)) {
			surface_free(pause_surface);
		}
	}
	
	if (!global.game_paused) {
		// Do time
		global.save_active[SAVE.TIME] += 1 / global.setting[SETTING.FRAMERATE];
		
		// Retry
		if (keyboard_check_pressed(global.button[BUTTON.RETRY])) {
			savedata_save(SAVE.DEATH, SAVE.TIME);
			savedata_load();
			
			resetting_room = global.save[SAVE.ROOM];
		}
	}
}

// Main menu
if (keyboard_check_pressed(global.button_world[BUTTON_WORLD.MENU]))
	game_restart();

// Quit
if (keyboard_check_pressed(global.button_world[BUTTON_WORLD.QUIT]))
	game_end();

// Fullscreen
if (keyboard_check_pressed(global.button_world[BUTTON_WORLD.FULLSCREEN])) {
	setting_set(SETTING.FULLSCREEN, !global.setting[SETTING.FULLSCREEN]);
	
	// Set menu text in case of changing fullscreen
	if (instance_exists(obj_Menu)) {
		obj_Menu.setting[0] = global.setting[SETTING.FULLSCREEN] ? "true" : "false";
	}
}

// Screenshot
if (keyboard_check_pressed(global.button_world[BUTTON_WORLD.SCREENSHOT]))
	screen_save(string_lettersdigits(date_datetime_string(date_current_datetime())) + ".png");