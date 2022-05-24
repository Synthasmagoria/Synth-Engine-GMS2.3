///@func player_yvelocity_limits()
function player_yvelocity_limits() constructor {
	normal = fps_adjust(9.0)
	water = fps_adjust(2.4) 
	vine = fps_adjust(2.4)
}

function player_set_defaults() {
	with oPlayer {
		var _varnames = variable_struct_get_names(defaults)
		for (var i = variable_struct_names_count(defaults) - 1; i >= 0; i--)
			variable_instance_set(id, _varnames[i], deep_copy(defaults[$_varnames]))
	}
}

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

///@func player_set_weapon(wobj)
///@arg {object} weapon_object
function player_set_weapon(wobj) {
	with oPlayer {
		if wobj != weapon_object {
			if instance_exists(weapon)
				instance_destroy(weapon)
			
			weapon = noone
			weapon_object = wobj
			
			if wobj != -1 && wobj != undefined {
				weapon = instance_create_depth(x + hand.x, y + hand.y, depth - 1, wobj)
				weapon.set_image_angle(image_angle)
			}
		}
	}
}

///@func player_set_skin(skin)
///@desc Sets the sprites used for a player
///@arg {string} skin
function player_set_skin(a) {
	with oPlayer {
		if a == 0 or a == "" or a == -1 {
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

///@func player_set_gravity_direction(dir, reset_velocity)
function player_set_gravity_direction(dir, reset_velocity = true) {
	with oPlayer {
		dir = wrap(dir, 0, 359)
		
		if gravity_direction != dir {
		
			gravity_direction = dir
		
			if gravity_direction_is_rotation
				image_angle = dir
		
			if gravity_is_diagonal() {
				vine_check_distance = 2
				situated_check_distance = 2
			} else {
				vine_check_distance = 1
				situated_check_distance = 1
			}
			
			var _rad = degtorad(dir)
			rotation_matrix.set(cos(_rad), sin(_rad), -sin(_rad), cos(_rad))
			
			right.set(1, 0)
			down.set(0, 1)
			mult_mat2_vec2(rotation_matrix, right, right)
			mult_mat2_vec2(rotation_matrix, down, down)
			mult_mat2_vec2(rotation_matrix, defaults.hand, hand)
			
			if instance_exists(weapon) {
				weapon.set_image_angle(image_angle)
			}
			
			velocity.y *= !reset_velocity
			
			player_refresh_airjumps()
		}
	}
}

///@func player_refresh_airjumps()
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