///@func				player_jump(vspd, snd)
///@arg {real} vspd		Vertical speed of the jump
///@desc				Sets the vspeed and plays a sound
function player_jump(vs) {
	vspeed = vs;
	situated = false;
}

///@func			player_gravity_compatible(inst)
///@arg {real} inst Instance to check
///@desc
/*
	This function assumes that the object you're checking agains has a default
	image_angle that is compatible with gravity direction 270
*/
function player_gravity_compatible(inst) {
	return grav_dir == wrap(inst.image_angle + 270, 0, 359);
}

///@func
function player_gravity_is_diagonal() {
	return frac(grav_dir / 90) != 0
}

///@func			player_set_gravity_direction(dir)
///@arg {real} dir	Gravity direction
///@desc			Safely sets the gravity direction of the player
function player_set_gravity_direction(dir) {
	grav_dir = wrap(dir, 0, 359);
	image_angle = grav_dir - 270;
	
	right_vector.set(
		lengthdir_x(1, grav_dir + 90),
		lengthdir_y(1, grav_dir + 90));
	down_vector.set(
		lengthdir_x(1, grav_dir),
		lengthdir_y(1, grav_dir));
}

///@func					player_kill([inst/obj])
///@desc					Creates a gameover scenario
///@arg {real} inst/obj		The instance or object to kill
function player_kill(inst_obj) {
	if (!g.debug_nodeath) {
		g.save_active[SAVE.DEATH]++;
		savedata_save(SAVE.DEATH, SAVE.TIME);
		
		if (!instance_exists(obj_Gameover))
			instance_create_depth(0, 0, depth, obj_Gameover);
		
		with (inst_obj) {
			instance_create_depth(x, y, g.player_blood_depth, obj_BloodEmitter);
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
	return player_spawn(g.save_active[SAVE.X], g.save_active[SAVE.Y]);
}

///@func			player_spawn(x, y)
///@arg {real} x	x
///@arg {real} y	y
///@desc			Spawns player at the set position
function player_spawn(xx, yy) {
	return instance_create_depth(
		xx,
		yy,
		g.player_depth,
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
		g.save_active[SAVE.X] = argument[0];
		g.save_active[SAVE.Y] = argument[1];
		g.save_active[SAVE.GRAVITY_DIRECTION] = argument[2];
		g.save_active[SAVE.FACING] = 1;
	}
	else
	{
		g.save_active[SAVE.X] = obj_Player.x;
		g.save_active[SAVE.Y] = obj_Player.y;
		g.save_active[SAVE.GRAVITY_DIRECTION] = obj_Player.grav_dir;
		g.save_active[SAVE.FACING] = obj_Player.facing;
	}

	if (argument_count >= 4)
		g.save_active[SAVE.ROOM] = room_get_name(argument[2]);
	else
		g.save_active[SAVE.ROOM] = room_get_name(room);

	savedata_save();
}

///@func player_situated()
///@desc Checks if situated (depends on vspeed & gravity)
function player_situated() {
	return place_meeting(x, y + 1, obj_Block) && vspeed >= 0;
}
