
draw_self();

//draw_text_outline(x, y, string(hspeed) + ", " + string(vspeed), c_black);

if (instance_exists(obj_Player))
{
    var _platDir = image_angle + 90 + (obj_Player.image_angle - image_angle);
	var _top = new vec2(0.0, 0.0);
	
	if (abs(angle_difference(obj_Player.image_angle, image_angle)) != 90)
    	_top.set(
        	x + lengthdir_x(sprite_height / 2, _platDir),
        	y + lengthdir_y(sprite_height / 2, _platDir));
    else
    	_top.set(
        	x + lengthdir_x(sprite_width / 2, _platDir),
        	y + lengthdir_y(sprite_width / 2, _platDir));
	
	var _abovePlatform = abs(angle_difference(_platDir, point_direction(_top.x, _top.y, obj_Player.x, obj_Player.y))) < 90;
    draw_set_color(c_yellow);
    draw_circle(
        _top.x,
        _top.y,
        4, false);
    
    draw_line(x, y, x + (_top.x - x) * 4, y + (_top.y - y) * 4);
    draw_set_color(c_white);
    
    if (_abovePlatform)
        image_blend = c_green;
    else
        image_blend = c_red;
}