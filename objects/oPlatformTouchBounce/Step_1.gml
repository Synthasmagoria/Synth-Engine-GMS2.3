///@desc Collisions

hspeed = place_meeting(x + hspeed, y, oBlock) ? hspeed * -1 : hspeed
vspeed = place_meeting(y + vspeed, y, oBlock) ? vspeed * -1 : vspeed