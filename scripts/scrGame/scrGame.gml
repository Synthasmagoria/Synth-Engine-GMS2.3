///@desc Checks if the world is resetting the room
///@func game_is_resetting_room()
function game_is_resetting_room() {
	return oGame.resetting_room != ""
}

///@desc Gets the room that is being restarted to
///@func game_get_resetting_room()
function game_get_resetting_room() {
	return oGame.resetting_room
}

///@func game_return_to_menu()
function game_return_to_menu() {
	///@desc Save death, time & free memory
	if (global.game_running) {
		savedata_save("time")
		savedata_save("death")
		savedata_write()
	}
	
	instance_destroy(oPlayer)
	
	global.game_running = false
	global.game_playing = false
	global.game_paused = false
	
	// Free memory
	if (surface_exists(pause_surface))
		surface_free(pause_surface)
	
	room_goto(global.menu_room)
}