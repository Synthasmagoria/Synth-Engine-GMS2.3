/*
	tldr Functions that do save-related stuff go here
	
	There are two global arrays that are directly related to save data
	oSaveData.save & oSaveData.save_current
	
	oSaveData.save_current holds values that are used when saving the game
		* values from oSaveData.save_current are moved to oSaveData.save when calling savedata_save
	
	oSaveData.save holds values that are used when loading the game
		* values from oSaveData.save are moved to oSaveData.save_current when calling savedata_load
	
	THE SAVE IS ONLY WRITTEN TO A FILE WHEN CALLING savedata_write
	This means: if the crashes unexpectedly, the current save data will not be written.
	If you want the game to write the save every time savedata_save is called when you may
	put savedata_write at the end of the function.
*/	

///@func		savedata_load([index], ...)
///@desc		Loads a game state from a file
///@arg {real}	[index]
///@arg {real}	...
function savedata_load() {

	/*
		This function moves values in 'oSaveData.save_active' to values from 'oSaveData.save'.
		You choose whether to copy the whole array or only parts of it.
		To specify which parts of the array to copy use the global SAVE enum.
		Thereafter the game state will be set according to these values (savedata_start_game).
	*/

	ds_map_copy(oSaveData.save_active, oSaveData.save)

	savedata_start_game(true)
}

///@func savedata_set_defaults()
function savedata_set_defaults() {
	ds_map_copy(oSaveData.save, oSaveData.save_default)
	ds_map_copy(oSaveData.save_active, oSaveData.save_default)
	
	savedata_set_both("seed", random_get_seed())
}

///@func		savedata_new_game()
///@desc		Sets oSaveData.save and oSaveData.save_active to default values
function savedata_new_game() {

	savedata_set_defaults()
	
	savedata_start_game(false)
}

///@func	savedata_read()
///@desc	Reads values from save file of the set index
function savedata_read() {

	var savename = savedata_get_savename()

	if (file_exists(savename)) {
		var f = file_text_open_read(savename)
		
		var m = json_decode(file_text_read_string(f))
		
		for (var i = array_length(oSaveData.save_key) - 1; i >= 0; i--)
			if m[?oSaveData.save_key[i]] == undefined
				m[?oSaveData.save_key[i]] = oSaveData.save_default[?oSaveData.save_key[i]]
		
		ds_map_copy(oSaveData.save, m)
		
		ds_map_destroy(m)
		
		file_text_close(f)
		
		oSaveData.save_is_read = true
		
		return true
	}
	
	return false
}

///@func		savedata_save([key...])
///@desc		Moves values from oSaveData.save_current to oSaveData.save
///@arg {string}	[key...]
function savedata_save() {

	/*
		This script sets values in 'oSaveData.save' to values from 'oSaveData.save_active'.
		You choose whether to copy the whole array or only parts of it.
		To specify which parts of the array to copy use the global SAVE enum.
	*/

	if argument_count > 0
		for (i = 0; i < argument_count; i++)
			savedata_set(argument[i], savedata_get_active(argument[i]))
	else
		ds_map_copy(oSaveData.save, oSaveData.save_active)
	
	savedata_write()
}

///@func		savedata_start_game(spawn_player)
///@desc		Sets the game state based on the values in 'oSaveData.save_active'
///@arg {bool}	spawn_player
function savedata_start_game(spawn_player) {

	/*
		This function sets the game state based on values stored in 'oSaveData.save_active'.
		You may change this script to fit your needs as you add more saved values.
		Used in scripts 'savedata_new_game' and 'savedata_load'.
	*/

	if (spawn_player)
		player_respawn()

	var r = asset_get_index(savedata_get_active("room"))

	if (room == r)
		room_restart()
	else
		room_goto(r)

	global.game_playing = true
}

///@func		savedata_write()
///@desc		Writes save values in oSaveData.save to file of the set index
function savedata_write() {

	var f = file_text_open_write(savedata_get_savename())

	file_text_write_string(f, json_encode(oSaveData.save))

	file_text_close(f)
}

///@func		savedata_get_savename()
///@desc		Gets the name of a save file
function savedata_get_savename() {
	return oSaveData.save_prefix + string(oSaveData.save_index) + oSaveData.save_suffix	
}

///@func		savedata_exists()
///@desc		Checks if a save file exists
function savedata_exists() {
	return file_exists(savedata_get_savename())	
}

///@func		savedata_is_read()
///@desc		Checks if the data of the save index has been read
function savedata_is_read() {
	return oSaveData.save_is_read	
}

///@func		savedata_set_index(save_index)
///@desc		Sets a save index to be used
///@arg {real}	save_index
function savedata_set_index(save_index) {
	if (oSaveData.save_index != save_index) {
		oSaveData.save_is_read = false
		oSaveData.save_index = save_index
	}
}

///@func savedata_get_index()
///@desc Gets the currently used save index
function savedata_get_index() {
	return oSaveData.save_index	
}

///@func savedata_get(key)
///@arg {string} key
function savedata_get(key) {
	return oSaveData.save[?key]
}

///@func savedata_set(key, value)
///@arg {string} key
///@arg value
function savedata_set(key, val) {
	oSaveData.save[?key] = val
}

///@func savedata_get_active(key)
///@arg {string} key
function savedata_get_active(key) {
	return oSaveData.save_active[?key]
}

///@func savedata_set_active(key, value)
///@arg {string} key
///@arg value
function savedata_set_active(key, val) {
	oSaveData.save_active[?key] = val
}

///@func savedata_set_both(key, val)
///@arg {string} key
///@arg val
function savedata_set_both(key, val) {
	savedata_set(key, val)
	savedata_set_active(key, val)
}

///@desc	Saving as done in oSave and adjacent objects
///@func	savedata_save_player()
function savedata_save_player() {
	savedata_set_active("x", oPlayer.x)
	savedata_set_active("y", oPlayer.y)
	savedata_set_active("room", room_get_name(room))
	savedata_set_active("gravity_direction", oPlayer.vertical_direction)
	savedata_set_active("facing", oPlayer.facing)
	savedata_save()
}
