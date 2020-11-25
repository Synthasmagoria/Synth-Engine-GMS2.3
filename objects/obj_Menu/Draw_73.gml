///@desc Draw Menu

// Set draw position
var drawX, drawY;
drawX = menu_padding;
drawY = menu_padding;

// Set font
draw_set_font(font);

// Draw menu title
draw_text_transformed(drawX, drawY, menu[menu_index], menu_scale, menu_scale, 0);
drawY += font_height * menu_scale;

// Draw menu options
for (var i = 0; i < option_number[menu_index]; i++) {
	draw_set_color(option_color[menu_index, i]);
	draw_text(drawX, drawY, option[menu_index, i]);
	drawY += font_height;
}

draw_set_color(c_white);

// Draw selection arrow
drawX += option_width_max[menu_index];
drawY -= (option_number[menu_index] - option_index) * font_height;
draw_text(drawX, drawY, arrow);

// Draw settings/buttons
if (menu_index == menu_sub_settings) {
	drawX += arrow_width;
	drawY = menu_padding + font_height * menu_scale;
	
	for (var i = 0; i < option_number[menu_index]; i++) {
		draw_set_color(option_color[menu_index, i]);
		draw_text(drawX, drawY, setting[i]);
		drawY += font_height;
	}
} else if (menu_index == menu_sub_buttons) {
	drawX += arrow_width;
	drawY = menu_padding + font_height * menu_scale;
	
	for (var i = 0; i < option_number[menu_index]; i++) {
		draw_set_color(option_color[menu_index, i]);
		draw_text(drawX, drawY, button[i]);
		drawY += font_height;
	}
	
	if (button_changing) {
		drawX += button_width_max;
		drawY = menu_padding + font_height * menu_scale + font_height * option_index;
		
		draw_text(drawX, drawY, button_changing_alert);
	}
} else if (menu_index == menu_sub_save) {
	drawX = GAME_WIDTH - menu_padding - 20 * font_width;
	drawY = menu_padding + font_height * menu_scale;
	
	for (var i = 0; i < save_value_number; i++) {
		draw_text(drawX, drawY, save_value_name[i] + save_value[i]);
		drawY += font_height;
	}
}

draw_set_color(c_white);