///@desc Draw pause surface if paused

if (DEBUG) {
	draw_set_color(c_red);
	draw_set_font(0);
	draw_text(4, GAME_HEIGHT - string_height("W") - 4, global.debug_text);
	draw_set_color(c_white);
}

if (global.game_paused) {
	draw_surface_ext(pause_surface, 0, 0, 1, 1, 0, c_white, 1);
} else if (!global.game_paused && surface_exists(pause_surface)) {
	surface_free(pause_surface);	
}