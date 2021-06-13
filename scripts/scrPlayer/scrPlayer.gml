///@func					player_kill([inst/obj])
///@desc					Creates a gameover scenario
///@arg {real} inst/obj		The instance or object to kill
function player_kill(inst_obj) {
	if (!global.debug_nodeath) {
		savedata_set_active("death", savedata_get_active("death") + 1)
		savedata_save("death", "time")
		
		if (!instance_exists(oGameover))
			instance_create_depth(0, 0, depth, oGameover)
		
		with (inst_obj) {
			instance_create_depth(x, y, global.player_blood_depth, oBloodEmitter)
			instance_destroy()
		}
	}
}

///@func player_set_weapon(new_weapon)
///@arg {index} new_weapon
function player_set_weapon(new_weapon) {
	with oPlayer {
		if weapon_instance != -1 && instance_exists(weapon_instance)
			instance_destroy(weapon_instance)
		if new_weapon != -1 {
			weapon = new_weapon
			weapon_instance = instance_create_depth(x, y, depth + 1, weapon)
		}
	}
}

/*
	You may use this script to change player skin if you've added multiple player sprites
	Creds to vivi for this one
*/
///@func player_set_skin(skin)
///@desc Sets the sprites used for a player
///@arg {string} skin
function player_set_skin(a) {
	with oPlayer {
		if a == undefined or a == "" or a == -1 {
		    sprite_idle = sPlayerIdle
		    sprite_run = sPlayerRun
		    sprite_slide = sPlayerSlide
		    sprite_fall = sPlayerFall
		    sprite_jump = sPlayerJump
		} else {
		    sprite_idle = asset_get_index("sPlayerIdle"+a)
		    sprite_run = asset_get_index("sPlayerRun"+a)
		    sprite_slide = asset_get_index("sPlayerSlide"+a)
		    sprite_fall = asset_get_index("sPlayerFall"+a)
		    sprite_jump = asset_get_index("sPlayerJump"+a)
		}
	}
}

function player_queue_speed(hs, vs) {
	with oPlayer {queued_speed.set(queued_speed.x + hs, queued_speed.y + vs)}
}

function player_set_stopped(val) {
	with oPlayer {
		hspeed = 0
		vspeed = 0
		stopped = val
		remove_input()
	}
}

function player_set_frozen(val) {
	with oPlayer {
		frozen = val
		remove_input()
	}
}

///
function player_set_gravity(vert_dir) {
	vert_dir = sign(vert_dir)
	
	if (vert_dir != 0)
	{
		if (vert_dir == -1 && vertical_direction == 1) {
			y -= 3
			vspeed = 0
			player_refresh_airjumps()
		} else if (vert_dir == 1 && vertical_direction == -1) {
			y += 3
			vspeed = 0
			player_refresh_airjumps()
		}
		
		vertical_direction = vert_dir
		image_yscale = abs(image_yscale) * vert_dir
	}
}

function player_refresh_airjumps() {
	oPlayer.airjump_index = 0
}

///@desc	Respawns the player at the last saved position
///@func	player_respawn()
function player_respawn() {
	instance_destroy(oGameover)
	instance_destroy(oBloodEmitter)
	instance_destroy(oPlayer)
	
	var player = player_spawn(savedata_get("x"), savedata_get("y"))
	player.facing = savedata_get("facing")
	return player
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
		oPlayer)
}