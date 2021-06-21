///@desc Draw Menu

// Set draw position
var drawX, drawY
drawX = menu_padding
drawY = menu_padding

// Set font
draw_set_font(font)

// Draw menu title
draw_text_transformed(drawX, drawY, menu[menu_index], menu_scale, menu_scale, 0)
drawY += font_height * menu_scale

// Draw menu options
for (var i = 0; i < option_number[menu_index]; i++) {
	draw_set_color(option_color[menu_index, i])
	draw_text(drawX, drawY, option[menu_index, i])
	drawY += font_height
}

draw_set_color(c_white)

// Draw selection arrow
drawX += option_width_max[menu_index]
drawY -= (option_number[menu_index] - option_index) * font_height
draw_text(drawX, drawY, arrow)

// Draw settings/buttons
switch (menu_index) {
	case MENU_SUB_SETTINGS:
	case MENU_SUB_KEYBOARD:
	case MENU_SUB_GAMEPAD:
		var _button_changing_offset, _mapping_arr
		
		switch (menu_index) {
			case MENU_SUB_SETTINGS:
				_button_changing_offset = 0 // not needed
				_mapping_arr = setting
				break
			case MENU_SUB_KEYBOARD:
				_button_changing_offset = keyboard_width_max
				_mapping_arr = keyboard
				break
			case MENU_SUB_GAMEPAD:
				_button_changing_offset = gamepad_width_max
				_mapping_arr = gamepad
				break
		}
		
		drawX += arrow_width
		drawY = menu_padding + font_height * menu_scale
		
		for (var i = 0; i < option_number[menu_index]; i++) {
			draw_set_color(option_color[menu_index, i])
			draw_text(drawX, drawY, _mapping_arr[i])
			drawY += font_height
		}
		
		draw_set_color(c_white)
		
		if (button_changing != -1) {
			drawX += _button_changing_offset + font_width
			drawY = menu_padding + font_height * menu_scale + font_height * option_index
			
			draw_text(drawX, drawY, button_changing_alert + " " + string(button_changing_countdown))
		}
		break
	
	case MENU_SUB_SAVE:
		drawX = GAME_WIDTH - menu_padding - 20 * font_width
		drawY = menu_padding + font_height * menu_scale
		
		for (var i = 0; i < save_value_number; i++) {
			draw_text(drawX, drawY, save_value_name[i] + save_value[i])
			drawY += font_height
		}
		break
}

draw_set_color(c_white)

// Draw helping text
draw_set_halign(fa_right)
draw_text(
	room_width - menu_padding,
	menu_padding,
	"[" + keyboard_button_to_string(input_get_keyboard_mapping("jump")) + "]: Select, " + 
	"[" + keyboard_button_to_string(input_get_keyboard_mapping("shoot")) + "]: Back" + "\n" +
	"[" + keyboard_button_to_string(input_get_keyboard_mapping("left")) + "/" +
		keyboard_button_to_string(input_get_keyboard_mapping("right")) + "]: Change gradient setting")
draw_set_halign(fa_left)