///@desc Save value strings

if (savedata_is_read()) {
	save_value[0] = string(g.save[SAVE.DEATH]);
	save_value[1] = time_to_string(g.save[SAVE.TIME]);
} else {
	save_value[0] = "N/A";
	save_value[1] = "N/A";
}