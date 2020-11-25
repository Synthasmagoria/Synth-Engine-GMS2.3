///@descr Initialize variables

// Set in creation code
rate = 0;
ahead = 0;
time = 0;
object_number = 1;

object = obj_Killer;
xoffset = 0;
yoffset = 0;
hs = 0;
vs = 0;

/*
Assign an array to these variables like this:
object = [obj_X1, obj_X2, obj_X3];

e.g. object = [obj_Platform, obj_SpikeUp, obj_Cherry];
*/

// Do not set in creation code
time_incr = 1 * global.fps_calculation;