///@desc Save & free memory
if (g.game_playing) {
	savedata_save(SAVE.DEATH, SAVE.TIME);
	savedata_write();
}

g.game_playing = false;
g.game_paused = false;


// Free memory
if (surface_exists(pause_surface))
	surface_free(pause_surface);

if (part_system_exists(g.player_blood_part_sys))
	part_system_destroy(g.player_blood_part_sys);
	
if (part_type_exists(g.player_blood_part))
	part_type_destroy(g.player_blood_part);