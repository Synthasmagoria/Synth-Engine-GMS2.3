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
