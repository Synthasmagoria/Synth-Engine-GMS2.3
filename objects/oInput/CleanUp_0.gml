
ds_map_destroy(keyboard_mapping)
ds_map_destroy(keyboard_mapping_default)
ds_map_destroy(keyboard_mapping_exclusive)
ds_map_destroy(gamepad_mapping)
ds_map_destroy(gamepad_mapping_default)
ds_map_destroy(gamepad_mapping_exclusive)

ds_map_destroy(input)

if get_delay() > 0
    for (var i = get_delay() - 1; i >= 0; i--)
        ds_map_destroy(input_queue[i])
