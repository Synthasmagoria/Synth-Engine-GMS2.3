///@desc Create blood

part_particles_create(
	global.player_blood_part_sys,
	x,
	y,
	global.player_blood_part,
	blood_rate)

blood_number += blood_rate

if (blood_number >= blood_number_max)
	instance_destroy()