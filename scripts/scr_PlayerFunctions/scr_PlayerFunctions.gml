///@func					player_halign(block_id)
///@arg {real} block_id		Id of the block to align against
///@desc					Align with a block horizontally
function player_halign(block_id) {
	if (hspeed < 0)
		x = block_id.bbox_right - HITBOX_X1 + 1;
	else
		x = block_id.bbox_left - HITBOX_X2 - 1;
}

///@func					player_valign(block_id)
///@arg {real} block_id		Id of the block to align agains
///@desc					Align with a block vertically
function player_valign(block_id) {
	if (vspeed < 0)
		y = block_id.bbox_bottom - HITBOX_Y1 + 1;
	else
		y = block_id.bbox_top - HITBOX_Y2 - 1;
}

///@func				player_jump(vspd, snd)
///@arg {real} vspd		Vertical speed of the jump
///@desc				Sets the vspeed and plays a sound
function player_jump(vs) {
	vspeed = vs;
	situated = false;
}

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

///@desc				Saving as done in obj_Save and adjacent objects
///@func				scr_Save_Live([x], [y], [room])
///@arg {real} [x]		x position to save
///@arg {real} [y]		y position to save
///@arg {real} [room]	room to save
function player_save() {

	if (argument_count >= 2)
	{
		global.save_active[SAVE.X] = argument[0];
		global.save_active[SAVE.Y] = argument[1];
	}
	else
	{
		global.save_active[SAVE.X] = obj_Player.x;
		global.save_active[SAVE.Y] = obj_Player.y;
	}

	if (argument_count >= 3)
		global.save_active[SAVE.ROOM] = room_get_name(argument[2]);
	else
		global.save_active[SAVE.ROOM] = room_get_name(room);

	savedata_save();
}

///@desc					Spawns a bullet traveling in a direction
///@func					player_shoot(dir, spd, [xoffset], [yoffset])
///@arg {real} dir			Direction to shoot in
///@arg {real} spd			Speed of the bullet
///@arg {real} [xoffset]	x offset of the bullet spawn
///@arg {real} [yoffset]	y offset of the bullet spawn
function player_shoot(dir, spd) {
	var
	xoffset = 5,
	yoffset = -2;

	if (argument_count > 2)
	{
		xoffset += argument[2];
		yoffset += argument[3];
	}

	var bullet = instance_create_depth(x + xoffset * dir, y + yoffset, depth, obj_Bullet);
	bullet.hspeed = spd * dir;
	return bullet;
}

///@func player_situated()
///@desc Checks if situated (depends on vspeed & gravity)
function player_situated() {
	return place_meeting(x, y + 1, obj_Block) && vspeed >= 0;
}
