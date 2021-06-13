
// Save values
save = ds_map_create()
save_active = ds_map_create()
save_is_read = false
save_index = 0
save_number = 5
save_key = ["x", "y", "room", "death", "time", "item", "gravity_direction", "seed", "facing"]
save_prefix = "save"
save_suffix = ""

// Default save values (used when starting a new game)
save_default = ds_map_create()
for (var i = array_length(save_key) - 1; i >= 0; i--)
    save_default[?save_key[i]] = 0
save_default[?"room"] = "rEngine"
save_default[?"facing"] = 1
save_default[?"gravity_direction"] = 1

savedata_set_defaults()