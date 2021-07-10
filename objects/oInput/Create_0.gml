
if instance_number(object_index) > 1 {
    instance_destroy()
}

global.input = id

input = ds_map_create()
input_queue_index = 0
input_queue = []

keyboard_mapping = ds_map_create()
keyboard_mapping_default = ds_map_create()
keyboard_mapping_exclusive = ds_map_create()

gamepad_mapping = ds_map_create()
gamepad_mapping_default = ds_map_create()
gamepad_mapping_exclusive = ds_map_create()

key_keyboard = []
key_gamepad = []
key = []

input_mapping_add("jump",             vk_shift,   false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("shoot",            ord("Z"),   false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("left",             vk_left,    false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("right",            vk_right,   false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("up",               vk_up,      false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("down",             vk_down,    false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("skip",             ord("S"),   false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("retry",            ord("R"),   false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("suicide",          ord("Q"),   false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("pause",            ord("P"),   false,    INPUT_DEVICE.KEYBOARD)
input_mapping_add("menu",             vk_f2,      true,     INPUT_DEVICE.KEYBOARD)
input_mapping_add("fullscreen",       vk_f4,      true,     INPUT_DEVICE.KEYBOARD)
input_mapping_add("screenshot",       vk_f11,     true,     INPUT_DEVICE.KEYBOARD)
input_mapping_add("quit",             vk_escape,  true,     INPUT_DEVICE.KEYBOARD)

if DEBUG {
    input_mapping_add("debug_nodeath",    vk_delete,  true,     INPUT_DEVICE.KEYBOARD)
    input_mapping_add("debug_save",       vk_insert,  true,     INPUT_DEVICE.KEYBOARD)
    input_mapping_add("debug_warp",       ord("9"),   true,     INPUT_DEVICE.KEYBOARD)
    input_mapping_add("debug_next_room",  vk_pageup,  true,     INPUT_DEVICE.KEYBOARD)
    input_mapping_add("debug_prev_room",  vk_pagedown,true,     INPUT_DEVICE.KEYBOARD)
}

input_mapping_add("jump",     gp_face1,     false,   INPUT_DEVICE.GAMEPAD)
input_mapping_add("shoot",    gp_face3,     false,   INPUT_DEVICE.GAMEPAD)
input_mapping_add("left",     gp_padl,      false,   INPUT_DEVICE.GAMEPAD)
input_mapping_add("right",    gp_padr,      false,   INPUT_DEVICE.GAMEPAD)
input_mapping_add("up",       gp_padu,      false,   INPUT_DEVICE.GAMEPAD)
input_mapping_add("down",     gp_padd,      false,   INPUT_DEVICE.GAMEPAD)
input_mapping_add("skip",     gp_face2,     false,   INPUT_DEVICE.GAMEPAD)
input_mapping_add("retry",    gp_face4,     false,   INPUT_DEVICE.GAMEPAD)
input_mapping_add("suicide",  gp_select,    false,   INPUT_DEVICE.GAMEPAD)
input_mapping_add("pause",    gp_start,     false,   INPUT_DEVICE.GAMEPAD)

// Initialization code
key_keyboard = ds_map_keys_to_array(keyboard_mapping)
key_gamepad = ds_map_keys_to_array(gamepad_mapping)
key = ds_map_keys_to_array(input)

if !config_section_exists(CONFIG_SECTION_KEYBOARD) {
    input_mappings_save(INPUT_DEVICE.KEYBOARD)
} else {
    input_mappings_load(INPUT_DEVICE.KEYBOARD)
}

if !config_section_exists(CONFIG_SECTION_GAMEPAD) {
    input_mappings_save(INPUT_DEVICE.GAMEPAD)
} else {
    input_mappings_load(INPUT_DEVICE.GAMEPAD)
}

///@func get_input(input_map)
///@arg {map} input_map
get_input = function(im) {
    
    for (var i = array_length(key) - 1; i >= 0; i--)
        im[?key[i]].reset()
    
    var _key
    
    for (var i = array_length(key_keyboard) - 1; i >= 0; i--) {
        _key = key_keyboard[i]
        im[?_key].held |= keyboard_check(keyboard_mapping[?_key])
        im[?_key].pressed |= keyboard_check_pressed(keyboard_mapping[?_key])
        im[?_key].released |= keyboard_check_released(keyboard_mapping[?_key])
    }
    
    for (var i = array_length(key_gamepad) - 1; i >= 0; i--) {
        _key = key_gamepad[i]
        im[?_key].held |= gamepad_button_check(global.gamepad_slot, gamepad_mapping[?_key])
        im[?_key].pressed |= gamepad_button_check_pressed(global.gamepad_slot, gamepad_mapping[?_key])
        im[?_key].released |= gamepad_button_check_released(global.gamepad_slot, gamepad_mapping[?_key])
    }
}

get_delay = function() {
    return array_length(input_queue)
}