
global.gamepad_slot = 0

enum INPUT_DEVICE {
    KEYBOARD,
    GAMEPAD,
    __MAX
}

///@func input_struct()
function input_struct() constructor {
    held = false; pressed = false; released = false
    reset = function() {held = false; pressed = false; released = false}
}

///@func input_check(key)
///@arg {string} key
function input_check(key) {
    return global.input.input[?key].held
}

///@func input_check_pressed(key)
///@arg {string} key
function input_check_pressed(key) {
    return global.input.input[?key].pressed
}

///@func input_check_released(key)
///@arg {string} key
function input_check_released(key) {
    return global.input.input[?key].released
}

///@func input_set_defaults(device)
function input_set_defaults(device) {
	if device == INPUT_DEVICE.KEYBOARD
    	ds_map_copy(global.input.keyboard_mapping, global.input.keyboard_mapping_default)
    else if device == INPUT_DEVICE.GAMEPAD
    	ds_map_copy(global.input.gamepad_mapping, global.input.gamepad_mapping_default)
}

///@desc Deeply copies the content of an input map
///@func input_map_copy(map, src)
///@arg {map} map
///@arg {map} src
function input_map_copy(m, src) {
    for (var i = array_length(key) - 1; i >= 0; i--) {
        m[?key[i]].held = src[?key[i]].held
        m[?key[i]].pressed = src[?key[i]].pressed
        m[?key[i]].released = src[?key[i]].released
    }
}

///@func input_keyboard_mapping_exists(key)
function input_keyboard_mapping_exists(key) {
    return global.input.keyboard_mapping[?key] != undefined
}

///@func input_gamepad_mapping_exists(key)
function input_gamepad_mapping_exists(key) {
    return global.input.gamepad_mapping[?key] != undefined
}

///@func input_mapping_add(key, mapping, exclusive, device)
function input_mapping_add(key, mapping, exclusive, device) {
    if device == INPUT_DEVICE.KEYBOARD && !input_keyboard_mapping_exists(key) {
        global.input.keyboard_mapping[?key] = mapping
        global.input.keyboard_mapping_default[?key] = mapping
        global.input.keyboard_mapping_exclusive[?key] = exclusive
    } else if device == INPUT_DEVICE.GAMEPAD && !input_gamepad_mapping_exists(key) {
        global.input.gamepad_mapping[?key] = mapping
        global.input.gamepad_mapping_default[?key] = mapping
        global.input.gamepad_mapping_exclusive[?key] = exclusive
    }
    
    if global.input.input[?key] == undefined
        global.input.input[?key] = new input_struct()
}

///@desc Changes a pre-existing button binding
///@func input_mapping_change(key, mapping, device)
function input_mapping_change(key, mapping, device) {
    with global.input {
    	
    	var _keys, _exclusivity_map, _map
    	
    	switch device {
    		case INPUT_DEVICE.KEYBOARD:
    			if input_keyboard_mapping_exists(key) {
    				_keys = key_keyboard
    				_exclusivity_map = keyboard_mapping_exclusive
    				_map = keyboard_mapping
    			} else {
    				return
    			}
    			break
    			
    		case INPUT_DEVICE.GAMEPAD:
    			if input_gamepad_mapping_exists(key) {
    				_keys = key_gamepad
    				_exclusivity_map = gamepad_mapping_exclusive
    				_map = gamepad_mapping
    			} else {
    				return
    			}
    			break
    	}
    	
    	for (var i = array_length(_keys) - 1; i >= 0; i--) {
           	if (key != _keys[i]) { // make sure not to check agains itself
           		if (input_get_keyboard_mapping(_keys[i]) == mapping) { // check if a mapping is equal to the desired change
           			if (!_exclusivity_map[?_keys[i]]) {
           				_map[?_keys[i]] = _map[?key]
           				_map[?key] = mapping
           				return true
           			} else {
           				return false
           			}
           		}
           	}
        }
        
        _map[?key] = mapping
        return true
    }
}

///@func input_mappings_save(device)
function input_mappings_save(device) {
    var
    _section,
    _keys,
    _map
    
    ini_open(CONFIG_FILENAME)
    
    switch device {
        case INPUT_DEVICE.KEYBOARD:
            _section = CONFIG_SECTION_KEYBOARD
            _keys = global.input.key_keyboard
            _map = global.input.keyboard_mapping
            break
        case INPUT_DEVICE.GAMEPAD:
            _section = CONFIG_SECTION_GAMEPAD
            _keys = global.input.key_gamepad
            _map = global.input.gamepad_mapping
            ini_write_real(CONFIG_SECTION_SETTINGS, "gamepad_slot", global.gamepad_slot)
            break
        default:
        	ini_close()
            return
    }
    
    for (var i = 0; i < array_length(_keys); i++) {
        ini_write_real(_section, _keys[i], _map[?_keys[i]])
    }
    ini_close()
}

///@func input_mappings_load(device)
function input_mappings_load(device) {
    var
    _section,
    _keys,
    _map,
    _default_map
    
    ini_open(CONFIG_FILENAME)
    
    switch device {
        case INPUT_DEVICE.KEYBOARD:
            _section = CONFIG_SECTION_KEYBOARD
            _keys = global.input.key_keyboard
            _map = global.input.keyboard_mapping
            _default_map = global.input.keyboard_mapping_default
            break
        case INPUT_DEVICE.GAMEPAD:
            _section = CONFIG_SECTION_GAMEPAD
            _keys = global.input.key_gamepad
            _map = global.input.gamepad_mapping
            _default_map = global.input.gamepad_mapping_default
            global.gamepad_slot = ini_read_real(CONFIG_SECTION_SETTINGS, "gamepad_slot", 0)
            break
        default:
        	ini_close()
            return
    }
    
    for (var i = 0; i < array_length(_keys); i++) {
        _map[?_keys[i]] = ini_read_real(_section, _keys[i], _default_map[?_keys[i]])
    }
    ini_close()
}

///@func input_set_delay(frames)
///@arg {real} frames
function input_set_delay(frames) {
    
    frames = max(0, frames)
    
    with global.input {
        if get_delay() < frames {
            array_resize(input_queue, frames)
            for (var i = 0; i < get_delay(); i++) {
                input_queue[i] = ds_map_create()
                for (var ii = array_length(key) - 1; ii >= 0; ii--) {
                    input_queue[i][?key[ii]] = new input_struct()
                }
            }
        } else if get_delay() > frames {
            for (var i = get_delay() - 1; i >= frames; i--) {
                ds_map_destroy(input_queue[i])
            }
            array_resize(input_queue, frames)
        }
        
        if frames > 0
            input_queue_index = input_queue_index % frames
        else
            input_queue_index = 0
    }
}

///@func input_get_keyboard_mapping(key)
function input_get_keyboard_mapping(key) {
    return global.input.keyboard_mapping[?key]
}

///@func input_get_gamepad_mapping(key)
function input_get_gamepad_mapping(key) {
    return global.input.gamepad_mapping[?key]
}

///@func gamepad_button_to_string(button)
///@arg {real} button
function gamepad_button_to_string(button) {
    switch (button)
    {
        case gp_face1:      return "A/Cross";
        case gp_face2:      return "B/Circle";
        case gp_face3:      return "X/Square";
        case gp_face4:      return "Y/Triangle";
        case gp_shoulderl:  return "Left Bumper";
        case gp_shoulderlb: return "Left Trigger";
        case gp_shoulderr:  return "Right Bumper";
        case gp_shoulderrb: return "Right Trigger";
        case gp_select:     return "Select/Touch-Pad";
        case gp_start:      return "Start/Options";
        case gp_stickl:     return "Left Stick (pressed)";
        case gp_stickr:     return "Right Stick (pressed)";
        case gp_padu:       return "D-Pad Up";
        case gp_padd:       return "D-Pad Down";
        case gp_padl:       return "D-Pad Left";
        case gp_padr:       return "D-Pad Right";
        default:            return "Unknown";
    }
}

///@func				input_keyboard_button_to_string(button)
///@arg {real} button	Button unicode value
///@desc				Translates a button unicode to a readable string
function keyboard_button_to_string(button) {
	switch(button)
    {
        //special keys
        case vk_space:          return "Space";
        case vk_shift:          return "Shift";
        case vk_control:        return "Control";
        case vk_alt:            return "Alt";
        case vk_enter:          return "Enter";
        case vk_up:             return "Up";
        case vk_down:           return "Down";
        case vk_left:           return "Left";
        case vk_right:          return "Right";
        case vk_backspace:      return "Backspace";
        case vk_tab:            return "Tab";
        case vk_insert:         return "Insert";
        case vk_delete:         return "Delete";
        case vk_pageup:         return "Page Up";
        case vk_pagedown:       return "Page Down";
        case vk_home:           return "Home";
        case vk_end:            return "End";
        case vk_escape:         return "Escape";
        case vk_printscreen:    return "Print Screen";
        case vk_f1:             return "F1";
        case vk_f2:             return "F2";
        case vk_f3:             return "F3";
        case vk_f4:             return "F4";
        case vk_f5:             return "F5";
        case vk_f6:             return "F6";
        case vk_f7:             return "F7";
        case vk_f8:             return "F8";
        case vk_f9:             return "F9";
        case vk_f10:            return "F10";
        case vk_f11:            return "F11";
        case vk_f12:            return "F12";
        case vk_lshift:         return "Left Shift";
        case vk_rshift:         return "Right Shift";
        case vk_lcontrol:       return "Left Control";
        case vk_rcontrol:       return "Right Control";
        case vk_lalt:           return "Left Alt";
        case vk_ralt:           return "Right Alt";
        //numpad keys
        case 96:                return "0";
        case 97:                return "1";
        case 98:                return "2";
        case 99:                return "3";
        case 100:               return "4";
        case 101:               return "5";
        case 102:               return "6";
        case 103:               return "7";
        case 104:               return "8";
        case 105:               return "9";
        case 106:               return "*";
        case 107:               return "+";
        case 109:               return "-";
        case 110:               return ".";
        case 111:               return "/";
        //misc keys
        case 186:               return ";";
        case 187:               return "=";
        case 188:               return ",";
        case 189:               return "-";
        case 190:               return ".";
        case 191:               return "/";
        case 192:               return "`";
        case 219:               return "[";
        case 220:               return "Backslash";
        case 221:               return "]";
        case 222:               return "'";
        //other characters
        default:                return chr(button);
    }
}