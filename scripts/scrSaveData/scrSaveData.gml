/*
	tldr Functions that do save-related stuff go here
	
	On game start global.savedata gets a reference to an instance of oSaveData
	
	There are two global arrays that are directly related to save data
	oSaveData.save & oSaveData.save_current
	
	oSaveData.save_current holds values that are used when saving the game
		* values from oSaveData.save_current are moved to oSaveData.save when calling savedata_save
	
	global.savedata.save holds values that are used when loading the game
		* values from oSaveData.save are moved to oSaveData.save_current when calling savedata_load
	
	* values from oSaveData.save are written to a file when savedata_write is called
	* oSaveData.save receives values read from a save file when savedata_read is called
	
	There are helper functions to set save values
	* savedata_set/get
	* savedata_set/get_active
	* savedata_set/get_both
	Generally you'll only ever need to use savedata_set_active if you want something to be saved
	This is because that function "queues" a value to be saved the next
	time the player shoots a save (or the game is saved in any other way)
	
	THE SAVE IS ONLY WRITTEN TO A FILE WHEN CALLING savedata_write
	By default savedata_write is called every time the game is saved
	This can cause a lag spike if you're saving a fuckton of values.
	If you want to mitigate this potential lag spike then you may remove savedata_write from
	savedata_save. Just know that if you do this and the gamecrashes unexpectedly,
	the current save data will not be written. So do this at your own risk.
*/	

///@func savedata_struct()
function savedata_struct() constructor {
	x = 0
	y = 0
	r = "rTest"
	death = 0
	time = 0
	item = 0
	gravity_direction = 0
	seed = random_get_seed()
	facing = 1
	skin = ""
	weapon = "oGun"
}

///@func		savedata_load([index], ...)
///@desc		Loads a game state from a file
///@arg {real}	[index]
///@arg {real}	...
function savedata_load() {

	/*
		This function moves values in 'global.savedata.save_active' to values from 'global.savedata.save'.
		You choose whether to copy the whole array or only parts of it.
		To specify which parts of the array to copy use the global SAVE enum.
		Thereafter the game state will be set according to these values (savedata_start_game).
	*/

	global.savedata.save_active = deep_copy(global.savedata.save)

	savedata_start_game(true)
}

///@func savedata_set_defaults()
function savedata_set_defaults() {
	global.savedata.save = deep_copy(global.savedata.save_default)
	global.savedata.save_active = deep_copy(global.savedata.save_default)
	
	savedata_set_both("seed", random_get_seed())
}

///@func		savedata_new_game()
///@desc		Sets global.savedata.save and global.savedata.save_active to default values
function savedata_new_game() {

	savedata_set_defaults()
	
	savedata_start_game(false)
}

///@func	savedata_read()
///@desc	Reads values from save file of the set index
function savedata_read() {

	var savename = savedata_get_savename()

	if (file_exists(savename)) {
		var
		f = file_text_open_read(savename),
		struct = json_parse(file_text_read_string(f))
		
		for (var i = array_length(global.savedata.save_key) - 1; i >= 0; i--)
			if struct[$global.savedata.save_key[i]] == undefined
				global.savedata.save[$global.savedata.save_key[i]] = global.savedata.save_default[$global.savedata.save_key[i]]
			else
				global.savedata.save[$global.savedata.save_key[i]] = struct[$global.savedata.save_key[i]]
		
		delete struct
		
		file_text_close(f)
		
		global.savedata.save_is_read = true
		
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
	*/

	if argument_count > 0
		for (i = 0; i < argument_count; i++)
			savedata_set(argument[i], savedata_get_active(argument[i]))
	else
		global.savedata.save = deep_copy(global.savedata.save_active)
	
	
	
	savedata_write()
}

///@func savedata_set_slot(slot)
///@desc Sets the save slot
function savedata_set_slot(slot) {
	global.savedata.save_index = slot
}

///@func savedata_get_slot()
///@desc Sets the save slot
function savedata_get_slot() {
	return global.savedata.save_index
}

///@func		savedata_start_game(spawn_player)
///@desc		Sets the game state based on the values in 'oSaveData.save_active'
///@arg {bool}	spawn_player
function savedata_start_game(spawn_player) {

	/*
		This function sets the game state based on values stored in 'global.savedata.save_active'.
		You may change this script to fit your needs as you add more saved values.
		Used in scripts 'savedata_new_game' and 'savedata_load'.
	*/

	if (spawn_player)
		player_respawn()

	var r = asset_get_index(savedata_get_active("r"))

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

	file_text_write_string(f, json_stringify(global.savedata.save))

	file_text_close(f)
}

///@func		savedata_get_savename()
///@desc		Gets the name of a save file
function savedata_get_savename() {
	return global.savedata.save_prefix + string(global.savedata.save_index) + global.savedata.save_suffix	
}

///@func		savedata_exists()
///@desc		Checks if a save file exists
function savedata_exists() {
	return file_exists(savedata_get_savename())	
}

///@func		savedata_is_read()
///@desc		Checks if the data of the save index has been read
function savedata_is_read() {
	return global.savedata.save_is_read	
}

///@func		savedata_set_index(save_index)
///@desc		Sets a save index to be used
///@arg {real}	save_index
function savedata_set_index(save_index) {
	if (global.savedata.save_index != save_index) {
		global.savedata.save_is_read = false
		global.savedata.save_index = save_index
	}
}

///@func savedata_get_index()
///@desc Gets the currently used save index
function savedata_get_index() {
	return global.savedata.save_index	
}

///@func savedata_get(key)
///@arg {string} key
function savedata_get(key) {
	return global.savedata.save[$key]
}

///@func savedata_set(key, value)
///@arg {string} key
///@arg value
function savedata_set(key, val) {
	global.savedata.save[$key] = val
}

///@func savedata_get_active(key)
///@arg {string} key
function savedata_get_active(key) {
	return global.savedata.save_active[$key]
}

///@func savedata_set_active(key, value)
///@arg {string} key
///@arg value
function savedata_set_active(key, val) {
	global.savedata.save_active[$key] = val
}

///@func savedata_set_both(key, val)
///@arg {string} key
///@arg val
function savedata_set_both(key, val) {
	savedata_set(key, val)
	savedata_set_active(key, val)
}

///@desc	Saving as you'd expect when shooting oSave or triggering an object with saving funtionality
///@func	savedata_save_player()
function savedata_save_player() {
	savedata_set_active("x", oPlayer.x)
	savedata_set_active("y", oPlayer.y)
	savedata_set_active("r", room_get_name(room))
	savedata_set_active("gravity_direction", oPlayer.gravity_direction)
	savedata_set_active("facing", oPlayer.facing)
	savedata_set_active("weapon", object_get_name(oPlayer.weapon_object))
	savedata_save()
}
