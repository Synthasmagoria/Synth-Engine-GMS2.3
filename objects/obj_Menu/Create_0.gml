///@desc Initialize variables

// Menu variables
menu_index = 0;
menu_number = 6;
menu_padding = 4;
menu_scale = 2;

menu_sub_main = 0;
menu_sub_save = 1;
menu_sub_start = 2;
menu_sub_overwrite = 3;
menu_sub_settings = 4;
menu_sub_buttons = 5;

// Option variables
option_index = 0;
option_number = array_create(menu_number);
option_number[menu_sub_main] = 4;
option_number[menu_sub_save] = global.save_number;
option_number[menu_sub_start] = 2;
option_number[menu_sub_overwrite] = 2;
option_number[menu_sub_settings] = SETTING.NUMBER + 1;
option_number[menu_sub_buttons] = BUTTON.NUMBER + BUTTON_WORLD.NUMBER + 1;

// Font variables
font = f_Default12;
draw_set_font(font);
font_width = string_width("0");
font_height = string_height("0");

// Button variables
button_changing = false;
button_changing_alert = "changing...";
button_width_max = 0;

// Selection arrow variables
arrow = "<-";
arrow_space = font_width;
arrow_width = string_length(arrow) * font_width + arrow_space;

fps_min = 50;
fps_max = 360;
fps_change = 10;

#region Menu titles, option names and their corresponding settings/buttons

// Menu titles
menu = array_create(menu_number, "");
menu[menu_sub_main] = "Synth engine omnigrav";
menu[menu_sub_save] = "Select Save";
menu[menu_sub_start] = "Game";
menu[menu_sub_overwrite] = "Overwrite save?";
menu[menu_sub_settings] = "Settings";
menu[menu_sub_buttons] = "Button Configuration";

// Option names / colors
for (var i = 0; i < menu_number; i++) {
	for (var ii = 0; ii < option_number[i]; ii++) {
		option[i, ii] = "";
		option_color[i, ii] = c_white;
	}
}
option[menu_sub_main,0] = "Play";
option[menu_sub_main,1] = "Settings";
option[menu_sub_main,2] = "Buttons";
option[menu_sub_main,3] = "Quit";
for (var i = 0; i < global.save_number; i++) {
	option[menu_sub_save,i] = "Save " + string(i+1);
}
option[menu_sub_start,0] = "Continue";
option[menu_sub_start,1] = "Start New Game";
option[menu_sub_overwrite,0] = "No";
option[menu_sub_overwrite,1] = "Yes";
option[menu_sub_settings,0] = "Fullscreen:";
option[menu_sub_settings,1] = "Smoothing:";
option[menu_sub_settings,2] = "Scale:";
option[menu_sub_settings,3] = "Framerate:";
option[menu_sub_settings,4] = "Music:";
option[menu_sub_settings,5] = "Sound:";
option[menu_sub_settings,6] = "Vsync:";
option[menu_sub_settings,7] = "Gravity control:";
option[menu_sub_settings,8] = "Set defaults";
option[menu_sub_buttons,0] = "Right:";
option[menu_sub_buttons,1] = "Up:";
option[menu_sub_buttons,2] = "Left:";
option[menu_sub_buttons,3] = "Down:";
option[menu_sub_buttons,4] = "Jump:";
option[menu_sub_buttons,5] = "Shoot:";
option[menu_sub_buttons,6] = "Retry:";
option[menu_sub_buttons,7] = "Pause:";
option[menu_sub_buttons,8] = "Suicide:";
option[menu_sub_buttons,9] = "Set defaults";
option[menu_sub_buttons,10] = "Menu:";
option[menu_sub_buttons,11] = "Quit:";
option[menu_sub_buttons,12] = "Fullscreen:";
option[menu_sub_buttons,13] = "Screenshot:";

option_color[menu_sub_buttons,10] = c_gray;
option_color[menu_sub_buttons,11] = c_gray;
option_color[menu_sub_buttons,12] = c_gray;
option_color[menu_sub_buttons,13] = c_gray;

// Save string array
save_value_number = 2;
save_value = array_create(save_value_number, "");
save_value_name = array_create(save_value_number);
save_value_name[0] = "Deaths: ";
save_value_name[1] = "Time: ";

// Settings string array
setting = array_create(option_number[menu_sub_settings], "");
event_user(1);

// Setting changes
setting_music_change = 0.1;
setting_sound_change = 0.1;

setting_scale_max = min(
	floor(display_get_width() / GAME_WIDTH * 2) / 2,
	floor(display_get_height() / GAME_HEIGHT * 2) / 2
);

// Button string array
button = array_create(option_number[menu_sub_buttons], "");
for (var i = 0; i < BUTTON.NUMBER; i++)
	button[i] = button_to_string(global.button[i]);

button[10] = button_to_string(global.button_world[BUTTON_WORLD.MENU]);
button[11] = button_to_string(global.button_world[BUTTON_WORLD.QUIT]);
button[12] = button_to_string(global.button_world[BUTTON_WORLD.FULLSCREEN]);
button[13] = button_to_string(global.button_world[BUTTON_WORLD.SCREENSHOT]);
#endregion

// Get the maximum option width to draw the menu more easily
option_width_max = array_create(menu_number, 0);
for (var i = 0; i < menu_number; i++) {
	for (var ii = 0; ii < option_number[i]; ii++) {
		var optionWidth;
		optionWidth = string_length(option[i,ii]) * font_width;
		option_width_max[i] = option_width_max[i] < optionWidth ? optionWidth : option_width_max[i];
	}
}

for (var i = 0; i < option_number[menu_sub_buttons]; i++) {
	var buttonWidth;
	buttonWidth = string_length(button[i]) * font_width;
	button_width_max = button_width_max < buttonWidth ? buttonWidth : button_width_max;
}