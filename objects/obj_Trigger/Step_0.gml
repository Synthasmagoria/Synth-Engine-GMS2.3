///@desc Trigger

if (place_meeting(x, y, obj_Player)) {
	
	if (trg_dir != 0) {
		trigger(trg, trg_dir);
	} else {
		trigger(trg);
	}
	
	if (trg_snd != -1) {
		audio_play_sound(trg_snd, 0, false);
	}
	
	if (destroy) {
		instance_destroy();
	}
}