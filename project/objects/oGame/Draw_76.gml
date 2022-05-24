///@desc Pause surface & Smoothing

gpu_set_texfilter(false)

if (global.game_paused && !surface_exists(pause_surface)) {
		pause_surface = surface_create(GAME_WIDTH, GAME_HEIGHT)
		
		surface_copy(pause_surface, 0, 0, application_surface)
		
		surface_set_target(pause_surface)
		
		draw_set_color(c_black)
		draw_set_alpha(pause_dim)
		draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false)
		draw_set_color(c_white)
		draw_set_alpha(1.0)
		
		draw_text(0, 0, "DEATH: " + string(savedata_get_active("death")))
		draw_text(0, 16, "TIME: " + time_to_string(savedata_get_active("time") + 1))
		
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_text_transformed(GAME_WIDTH / 2, GAME_HEIGHT / 2, "PAUSE", 1, 1, 0)
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)
		
		surface_reset_target()
}