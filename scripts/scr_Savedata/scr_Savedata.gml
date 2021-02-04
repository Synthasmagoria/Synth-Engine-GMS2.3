/*
	tldr; Functions that do save-related stuff go here
	
	There are two global arrays that are directly related to save data
	g.save & g.save_current
	
	g.save_current holds values that are used when saving the game
		* values from g.save_current are moved to g.save when calling savedata_save
	
	g.save holds values that are used when loading the game
		* values from g.save are moved to g.save_current when calling savedata_load
	
	THE SAVE IS ONLY WRITTEN TO A FILE WHEN CALLING savedata_write
	This means: if the crashes unexpectedly, the current save data will not be written.
	If you want the game to write the save every time savedata_save is called when you may
	put savedata_write at the end of the function.
*/

///@func		savedata_load([index], [...])
///@desc		Loads a game state from a file
///@arg {real}	[index]
///@arg {real}	[...]
function savedata_load() {

	/*
		This function moves values in 'g.save_active' to values from 'g.save'.
		You choose whether to copy the whole array or only parts of it.
		To specify which parts of the array to copy use the global SAVE enum.
		Thereafter the game state will be set according to these values (savedata_start_game).
	*/


	if (argument_count > 0) {
		for (var i = 0; i < argument_count; i++) {
			g.save_active[argument[i]] = g.save[argument[i]];
		}
	} else {
		for (var i = 0; i < SAVE.NUMBER; i++) {
			g.save_active[i] = g.save[i];
		}
	}

	savedata_start_game(true);
}

///@func		savedata_new_game()
///@desc		Sets g.save and g.save_active to default values
function savedata_new_game() {

	for (var i = 0; i < SAVE.NUMBER; i++) {
		g.save[i] = g.save_default[i];
		g.save_active[i] = g.save_default[i];
	}
	
	savedata_start_game(false);
}

///@func	savedata_read()
///@desc	Reads values from save file of the set index
function savedata_read() {

	var savename = savedata_get_savename();

	if (file_exists(savename)) {
		var f = file_text_open_read(savename);
	
		for (var i = 0; i < SAVE.NUMBER; i++) {
			if (!g.save_as_string[i]) {
				g.save[i] = file_text_read_real(f);
			} else {
				g.save[i] = file_text_read_string(f);
			}
			
			file_text_readln(f);
		}
	
		file_text_close(f);
		
		g.save_is_read = true;
	
		return true; // Read from file
	} else {
		return false; // Failed to read from file
	}
}

///@func		savedata_save([index], [...])
///@desc		Moves values from g.save_current to g.save
///@arg {real}	[index]
///@arg {real}	[...]
function savedata_save() {

	/*
		This script sets values in 'g.save' to values from 'g.save_active'.
		You choose whether to copy the whole array or only parts of it.
		To specify which parts of the array to copy use the global SAVE enum.
	*/

	if (argument_count > 0) {
		for (var i = 0; i < argument_count; i++) {
			g.save[argument[i]] = g.save_active[argument[i]];
		}
	} else {
		for (var i = 0; i < SAVE.NUMBER; i++) {
			g.save[i] = g.save_active[i];
		}
	}
	
	savedata_write();
}

///@func		savedata_start_game(spawn_player)
///@desc		Sets the game state based on the values in 'g.save_active'
///@arg {bool}	spawn_player
function savedata_start_game(spawn_player) {

	/*
		This function sets the game state based on values stored in 'g.save_active'.
		You may change this script to fit your needs as you add more saved values.
		Used in scripts 'savedata_new_game' and 'savedata_load'.
	*/

	if (spawn_player)
		player_respawn();

	var r = asset_get_index(g.save_active[SAVE.ROOM]);

	if (room == r)
		room_restart();
	else
		room_goto(r);

	g.game_playing = true;
}

///@func			savedata_write()
///@desc			Writes save values in g.save to file of the set index
function savedata_write() {

	var f = file_text_open_write(savedata_get_savename());

	for (var i = 0; i < SAVE.NUMBER; i++) {
		if (!g.save_as_string[i])
			file_text_write_real(f, g.save[i]);
		else
			file_text_write_string(f, g.save[i]);
		
		file_text_writeln(f);
	}

	file_text_close(f);
}

///@func		savedata_get_savename()
///@desc		Gets the name of a save file
function savedata_get_savename() {
	return string(g.save_index);	
}

///@func		savedata_exists()
///@desc		Checks if a save file exists
function savedata_exists() {
	return file_exists(savedata_get_savename());	
}

///@func		savedata_is_read()
///@desc		Checks if the data of the save index has been read
function savedata_is_read() {
	return g.save_is_read;	
}

///@func		savedata_set_index(save_index)
///@desc		Sets a save index to be used
///@arg {real}	save_index
function savedata_set_index(save_index) {
	if (g.save_index != save_index) {
		g.save_is_read = false;
		g.save_index = save_index;
	}
}

///@func savedata_get_index()
///@desc Gets the currently used save index
function savedata_get_index() {
	return g.save_index;	
}