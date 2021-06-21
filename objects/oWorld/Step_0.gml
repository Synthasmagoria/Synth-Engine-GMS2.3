///@desc Window/Game control

// Debug
if (DEBUG && global.game_running) {
	// Toggle nodeath
	if (input_check_pressed("debug_nodeath")) {
		global.debug_nodeath = !global.debug_nodeath
		audio_play_sound(sndBlockChange, 0, false)
	}
	
	// Save anywhere
	if (input_check_pressed("debug_save") && instance_exists(oPlayer)) {
		savedata_save_player()
		audio_play_sound(sndBlockChange, 0, false)
	}
	
	// Place the player at mouse
	if (mouse_check_button_pressed(mb_left)) {
		if (!instance_exists(oPlayer))
			player_respawn()
		
		oPlayer.x = mouse_x
		oPlayer.y = mouse_y
	}
	
	// Go to any room
	if (input_check_pressed("debug_warp")) {
		var r = asset_get_index(get_string("Go to room: ", ""))
		if (room_exists(r))
			room_goto(r)
	}
}

// Game control
if (global.game_running) {
	
	// Pause
	if (input_check_pressed("pause")) {
		global.game_paused = !global.game_paused
		
		if (global.game_paused) {
			instance_deactivate_all(true)
			instance_activate_object(oAudio)
			instance_activate_object(oInput)
			instance_activate_object(oSaveData)
		} else {
			instance_activate_all()
		}
		
		if (surface_exists(pause_surface)) {
			surface_free(pause_surface)
		}
	}
	
	if (!global.game_paused) {
		// Do time
		savedata_set_active("time", savedata_get_active("time") + f2sec(1) * global.game_playing)
		
		// Retry
		if (input_check_pressed("retry")) {
			savedata_save("death", "time")
			savedata_load()
			
			resetting_room = savedata_get("room")
		}
	}
}

// Main menu
if (input_check_pressed("menu"))
	world_restart_game()

// Quit
if (input_check_pressed("quit"))
	game_end()

// Fullscreen
if (input_check_pressed("fullscreen")) {
	config_setting_set(SETTING.FULLSCREEN, !global.setting[SETTING.FULLSCREEN])
	
	// Set menu text in case of changing fullscreen
	if (instance_exists(oMenu)) {
		oMenu.setting[0] = global.setting[SETTING.FULLSCREEN] ? "true" : "false"
	}
}

// Screenshot
if (input_check_pressed("screenshot"))
	screen_save(string_lettersdigits(date_datetime_string(date_current_datetime())) + ".png")