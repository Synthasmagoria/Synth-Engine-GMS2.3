///@desc Window/Game control

// Debug
if (DEBUG && g.game_playing) {
	// Toggle nodeath
	if (keyboard_check_pressed(g.debug_nodeath_button)) {
		g.debug_nodeath = !g.debug_nodeath;
		audio_play_sound(snd_BlockChange, 0, false);
	}
	
	// Save anywhere
	if (keyboard_check_pressed(g.debug_save_button) && instance_exists(obj_Player)) {
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
	if (keyboard_check_pressed(g.debug_warp_button)) {
		var r = asset_get_index(get_string("Go to room: ", ""));
		if (room_exists(r))
			room_goto(r);
	}
}

// Game control
if (g.game_playing) {
	
	// Pause
	if (keyboard_check_pressed(g.button[BUTTON.PAUSE])) {
		g.game_paused = !g.game_paused;
		
		if (g.game_paused) {
			instance_deactivate_all(true);
		} else {
			instance_activate_all();
		}
		
		if (surface_exists(pause_surface)) {
			surface_free(pause_surface);
		}
	}
	
	if (!g.game_paused) {
		// Do time
		g.save_active[SAVE.TIME] += 1 / g.setting[SETTING.FRAMERATE];
		
		// Retry
		if (keyboard_check_pressed(g.button[BUTTON.RETRY])) {
			savedata_save(SAVE.DEATH, SAVE.TIME);
			savedata_load();
			
			resetting_room = g.save[SAVE.ROOM];
		}
	}
}

// Main menu
if (keyboard_check_pressed(g.button_world[BUTTON_WORLD.MENU]))
	game_restart();

// Quit
if (keyboard_check_pressed(g.button_world[BUTTON_WORLD.QUIT]))
	game_end();

// Fullscreen
if (keyboard_check_pressed(g.button_world[BUTTON_WORLD.FULLSCREEN])) {
	setting_set(SETTING.FULLSCREEN, !g.setting[SETTING.FULLSCREEN]);
	
	// Set menu text in case of changing fullscreen
	if (instance_exists(obj_Menu)) {
		obj_Menu.setting[0] = g.setting[SETTING.FULLSCREEN] ? "true" : "false";
	}
}

// Screenshot
if (keyboard_check_pressed(g.button_world[BUTTON_WORLD.SCREENSHOT]))
	screen_save(date_datetime_string(date_current_datetime()));