///@desc Trigger

if (place_meeting(x, y, oPlayer)) {
	
	if (trg_dir != 0) {
		trigger(trg, trg_dir)
	} else {
		trigger(trg)
	}
	
	if (trg_snd != -1) {
		sfx_play_sound(trg_snd)
	}
	
	if (destroy) {
		instance_destroy()
	}
}