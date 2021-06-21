///@desc Checks if the world is resetting the room
///@func world_is_resetting()
function world_is_resetting() {
	return oWorld.resetting_room != ""
}

///@desc Gets the room that is being restarted to
///@func world_get_resetting_room()
function world_get_resetting_room() {
	return oWorld.resetting_room
}

///@func world_restart_game()
function world_restart_game() {
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
	
	if (part_system_exists(global.player_blood_part_sys))
		part_system_destroy(global.player_blood_part_sys)
		
	if (part_type_exists(global.player_blood_part))
		part_type_destroy(global.player_blood_part)
	
	room_goto(rMenu)
}