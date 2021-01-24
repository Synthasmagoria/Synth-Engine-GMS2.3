///@desc Control & movement

var
_bLeft = keyboard_check(g.button[BUTTON.LEFT]),
_bRight = keyboard_check(g.button[BUTTON.RIGHT]),
_bDir = _bRight - _bLeft;

if (keyboard_check_pressed(vk_space))
{
	image_angle += 45;
	grav_dir += 45;
}

var
_hspeed = new vec2(
	lengthdir_x(hs_run, grav_dir + 90) * _bDir,
	lengthdir_y(hs_run, grav_dir + 90) * _bDir);

hspeed = _hspeed.x;
vspeed = _hspeed.y;

if (place_meeting(x + hspeed, y + vspeed, obj_Block))
{
	var _colStep = _hspeed.normalize();
}