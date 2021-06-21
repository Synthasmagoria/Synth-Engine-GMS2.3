///@desc Initialize variables

// Menu variables
menu_index = 0
menu_number = 7
menu_padding = 4
menu_scale = 2

#macro MENU_SUB_MAIN 0
#macro MENU_SUB_SAVE 1
#macro MENU_SUB_START 2
#macro MENU_SUB_OVERWRITE 3
#macro MENU_SUB_SETTINGS 4
#macro MENU_SUB_KEYBOARD 5
#macro MENU_SUB_GAMEPAD 6

// Option variables
option_index = 0
option_number = array_create(menu_number)
option_number[MENU_SUB_MAIN] = 5
option_number[MENU_SUB_SAVE] = oSaveData.save_number
option_number[MENU_SUB_START] = 2
option_number[MENU_SUB_OVERWRITE] = 2
option_number[MENU_SUB_SETTINGS] = SETTING.NUMBER + 1
option_number[MENU_SUB_KEYBOARD] = 15
option_number[MENU_SUB_GAMEPAD] = 12

option_width_max = array_create(menu_number, 0)

// Font variables
font = fDefault
draw_set_font(font)
font_width = string_width("0")
font_height = string_height("0")

// Button variables
button_changing = -1
button_changing_alert = "changing..."
button_changing_countdown = 0
button_changing_length = 3
keyboard_width_max = 0
gamepad_width_max = 0

// Selection arrow variables
arrow = "<-"
arrow_space = font_width
arrow_width = string_length(arrow) * font_width + arrow_space

fps_min = 50
fps_max = 360
fps_change = 10

input_delay_min = 0
input_delay_max = 10

#region Menu titles, option names and their corresponding settings/buttons

// Menu titles
menu = array_create(menu_number, "")
menu[MENU_SUB_MAIN] = "Replace this menu"
menu[MENU_SUB_SAVE] = "Select Save"
menu[MENU_SUB_START] = "Game"
menu[MENU_SUB_OVERWRITE] = "Overwrite save?"
menu[MENU_SUB_SETTINGS] = "Settings"
menu[MENU_SUB_KEYBOARD] = "Keyboard Config"
menu[MENU_SUB_GAMEPAD] = "Gamepad Config"

// Option names / colors
for (var i = 0; i < menu_number; i++) {
	for (var ii = 0; ii < option_number[i]; ii++) {
		option[i][ii] = ""
		option_color[i][ii] = c_white
	}
}
option[MENU_SUB_MAIN][0] = "Play"
option[MENU_SUB_MAIN][1] = "Settings"
option[MENU_SUB_MAIN][2] = "Keyboard"
option[MENU_SUB_MAIN][3] = "Gamepad"
option[MENU_SUB_MAIN][4] = "Quit"
for (var i = 0; i < oSaveData.save_number; i++) {
	option[MENU_SUB_SAVE,i] = "Save " + string(i+1)
}
option[MENU_SUB_START][0] = "Continue"
option[MENU_SUB_START][1] = "Start New Game"
option[MENU_SUB_OVERWRITE][0] = "No"
option[MENU_SUB_OVERWRITE][1] = "Yes"
option[MENU_SUB_SETTINGS][0] = "Fullscreen:"
option[MENU_SUB_SETTINGS][1] = "Smoothing:"
option[MENU_SUB_SETTINGS][2] = "Scale:"
option[MENU_SUB_SETTINGS][3] = "Framerate:"
option[MENU_SUB_SETTINGS][4] = "Music:"
option[MENU_SUB_SETTINGS][5] = "Sound:"
option[MENU_SUB_SETTINGS][6] = "Vsync:"
option[MENU_SUB_SETTINGS][7] = "Gravity control:"
option[MENU_SUB_SETTINGS][8] = "Input delay:"
option[MENU_SUB_SETTINGS][9] = "Set defaults"

option_color[MENU_SUB_KEYBOARD][11] = c_gray
option_color[MENU_SUB_KEYBOARD][12] = c_gray
option_color[MENU_SUB_KEYBOARD][13] = c_gray
option_color[MENU_SUB_KEYBOARD][14] = c_gray

// Save string array
save_value_number = 2
save_value = array_create(save_value_number, "")
save_value_name = array_create(save_value_number)
save_value_name[0] = "Deaths: "
save_value_name[1] = "Time: "

// Settings string array
setting = array_create(option_number[MENU_SUB_SETTINGS], "")
event_user(1)

// Setting changes
setting_music_change = 0.1
setting_sound_change = 0.1

setting_scale_max = min(
	floor(display_get_width() / GAME_WIDTH * 2) / 2,
	floor(display_get_height() / GAME_HEIGHT * 2) / 2
)

// Button string array
keyboard_mapping = array_create(option_number[MENU_SUB_KEYBOARD], "")
keyboard_mapping[0] = "right"
keyboard_mapping[1] = "up"
keyboard_mapping[2] = "left"
keyboard_mapping[3] = "down"
keyboard_mapping[4] = "jump"
keyboard_mapping[5] = "shoot"
keyboard_mapping[6] = "retry"
keyboard_mapping[7] = "pause"
keyboard_mapping[8] = "suicide"
keyboard_mapping[9] = "skip"
keyboard_mapping[11] = "menu"
keyboard_mapping[12] = "quit"
keyboard_mapping[13] = "fullscreen"
keyboard_mapping[14] = "screenshot"

get_keyboard_button_strings = function() {
	for (var i = 0; i < option_number[MENU_SUB_KEYBOARD]; i++)
		if keyboard_mapping[i] != ""
			keyboard[i] = keyboard_button_to_string(input_get_keyboard_mapping(keyboard_mapping[i]))
}

keyboard = array_create(option_number[MENU_SUB_KEYBOARD], "")
for (var i = 0; i < option_number[MENU_SUB_KEYBOARD]; i++)
	if keyboard_mapping[i] != ""
		option[MENU_SUB_KEYBOARD][i] = string_upper(string_copy(keyboard_mapping[i], 1, 1)) + string_copy(keyboard_mapping[i], 2, string_length(keyboard_mapping[i]) - 1) + ":"
get_keyboard_button_strings()
option[MENU_SUB_KEYBOARD][10] = "Set defaults"

gamepad_mapping = array_create(option_number[MENU_SUB_GAMEPAD], "")
gamepad_mapping[0] = "right"
gamepad_mapping[1] = "up"
gamepad_mapping[2] = "left"
gamepad_mapping[3] = "down"
gamepad_mapping[4] = "jump"
gamepad_mapping[5] = "shoot"
gamepad_mapping[6] = "retry"
gamepad_mapping[7] = "pause"
gamepad_mapping[8] = "suicide"
gamepad_mapping[9] = "skip"

get_gamepad_button_strings = function() {
	for (var i = 0; i < option_number[MENU_SUB_GAMEPAD]; i++)
		if gamepad_mapping[i] != ""
			gamepad[i] = gamepad_button_to_string(input_get_gamepad_mapping(gamepad_mapping[i]))
	
	gamepad[11] = string(global.gamepad_slot)
}

gamepad = array_create(option_number[MENU_SUB_GAMEPAD], "")
for (var i = 0; i < option_number[MENU_SUB_GAMEPAD]; i++)
	if gamepad_mapping[i] != ""
		option[MENU_SUB_GAMEPAD][i] = string_upper(string_copy(gamepad_mapping[i], 1, 1)) + string_copy(gamepad_mapping[i], 2, string_length(gamepad_mapping[i]) - 1) + ":"
get_gamepad_button_strings()
option[MENU_SUB_GAMEPAD][10] = "Set defaults"
option[MENU_SUB_GAMEPAD][11] = "Gamepad slot:"
#endregion

// Get maximum string widths to draw the menu more easily
for (var i = 0; i < menu_number; i++)
	option_width_max[i] = array_get_max_string_width(option[i])

keyboard_width_max = array_get_max_string_width(keyboard)
gamepad_width_max = array_get_max_string_width(gamepad)