///@desc Move and bounce

hspeed *= place_meeting(x + hspeed, y, oBlock) ? -1 : 1
vspeed *= place_meeting(x, y + vspeed, oBlock) ? -1 : 1