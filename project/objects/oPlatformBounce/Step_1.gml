///@desc Collisions

hspeed = place_meeting(x + hspeed, y, oBlock) ? hspeed * -1 : hspeed
vspeed = place_meeting(x, y + vspeed, oBlock) ? vspeed * -1 : vspeed