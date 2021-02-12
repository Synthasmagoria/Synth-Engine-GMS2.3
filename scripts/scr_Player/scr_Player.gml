///@func					player_kill([inst/obj])
///@desc					Creates a gameover scenario
///@arg {real} inst/obj		The instance or object to kill
function player_kill(inst_obj) {
	if (!global.debug_nodeath) {
		global.save_active[SAVE.DEATH]++;
		savedata_save(SAVE.DEATH, SAVE.TIME);
		
		if (!instance_exists(obj_Gameover))
			instance_create_depth(0, 0, depth, obj_Gameover);
		
		with (inst_obj) {
			instance_create_depth(x, y, global.player_blood_depth, obj_BloodEmitter);
			instance_destroy();
		}
	}
}

///@desc	Respawns the player at the last saved position
///@func	player_respawn()
function player_respawn() {
	instance_destroy(obj_Gameover);
	instance_destroy(obj_BloodEmitter);
	instance_destroy(obj_Player);
	return player_spawn(global.save_active[SAVE.X], global.save_active[SAVE.Y]);
}

///@func			player_spawn(x, y)
///@arg {real} x	x
///@arg {real} y	y
///@desc			Spawns player at the set position
function player_spawn(xx, yy) {
	return instance_create_depth(
		xx,
		yy,
		global.player_depth,
		obj_Player);
}

///@desc					Saving as done in obj_Save and adjacent objects
///@func					player_save([x], [y], [room])
///@arg {real} [x]			x position to save
///@arg {real} [y]			y position to save
///@arg {real} [grav_dir]	rotation to save
///@arg {real} [room]		room to save
function player_save() {

	if (argument_count >= 3)
	{
		global.save_active[SAVE.X] = argument[0];
		global.save_active[SAVE.Y] = argument[1];
		global.save_active[SAVE.GRAVITY_DIRECTION] = argument[2];
		global.save_active[SAVE.FACING] = 1;
	}
	else
	{
		global.save_active[SAVE.X] = obj_Player.x;
		global.save_active[SAVE.Y] = obj_Player.y;
		global.save_active[SAVE.GRAVITY_DIRECTION] = obj_Player.gravity_direction;
		global.save_active[SAVE.FACING] = obj_Player.facing;
	}

	if (argument_count >= 4)
		global.save_active[SAVE.ROOM] = room_get_name(argument[2]);
	else
		global.save_active[SAVE.ROOM] = room_get_name(room);

	savedata_save();
}
