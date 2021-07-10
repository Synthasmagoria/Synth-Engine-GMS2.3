///@desc Window/Game control

// Debug
if (DEBUG && global.game_playing) {
	// Toggle nodeath
	if (input_check_pressed("debug_nodeath")) {
		global.debug_nodeath = !global.debug_nodeath
		sfx_play_sound(sndBlockChange)
	}
	
	// Save anywhere
	if (input_check_pressed("debug_save") && instance_exists(oPlayer)) {
		savedata_save_player()
		sfx_play_sound(sndBlockChange)
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
if (global.game_playing) {
	
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
		savedata_set_active("time", savedata_get_active("time") + f2sec(1))
		
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
	game_return_to_menu()

// Quit
if (input_check_pressed("quit"))
	game_end()

// Fullscreen
if (input_check_pressed("fullscreen")) {
	setting_set("fullscreen", !global.settings[$"fullscreen"])
	
	// Set menu text in case of changing fullscreen
	with oMenu event_user(1)
}

// Screenshot
if (input_check_pressed("screenshot"))
	screen_save(string_lettersdigits(date_datetime_string(date_current_datetime())) + ".png")