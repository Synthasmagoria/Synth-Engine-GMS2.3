///@desc Save value strings

if (savedata_is_read()) {
	save_value[0] = string(savedata_get("death"))
	save_value[1] = time_to_string(savedata_get("time"))
} else {
	save_value[0] = "N/A"
	save_value[1] = "N/A"
}