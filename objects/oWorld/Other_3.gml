///@desc Save death, time & free memory
if (global.game_playing) {
	savedata_save("time")
	savedata_save("death")
	savedata_write()
}

global.game_playing = false
global.game_paused = false


// Free memory
if (surface_exists(pause_surface))
	surface_free(pause_surface)

if (part_system_exists(global.player_blood_part_sys))
	part_system_destroy(global.player_blood_part_sys)
	
if (part_type_exists(global.player_blood_part))
	part_type_destroy(global.player_blood_part)