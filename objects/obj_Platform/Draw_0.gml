
draw_self();

var _top = new vec2(0.0, 0.0);

//draw_text_outline(x, y, string(hspeed) + ", " + string(vspeed), c_black);

if (instance_exists(obj_Player))
{
    var _upVec = new vec2(-obj_Player.down_vector.x, -obj_Player.down_vector.y);
    _top.set(
        x + lengthdir_x(sprite_height / 2, image_angle + 90 + obj_Player.image_angle),
        y + lengthdir_y(sprite_height / 2, image_angle + 90 + obj_Player.image_angle));
    
    draw_set_color(c_yellow);
    draw_circle(
        _top.x,
        _top.y,
        4, false);
    draw_set_color(c_white);
    
    if (abs(angle_difference(image_angle + 90, point_direction(_top.x, _top.y, obj_Player.x, obj_Player.y))) < 90)
        image_blend = c_green;
    else
        image_blend = c_red;
}