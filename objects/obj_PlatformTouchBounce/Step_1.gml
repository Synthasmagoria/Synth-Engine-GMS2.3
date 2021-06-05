///@desc Collisions

hspeed = place_meeting(x + hspeed, y, obj_Block) ? hspeed * -1 : hspeed;
vspeed = place_meeting(x, y + vspeed, obj_Block) ? vspeed * -1 : vspeed;