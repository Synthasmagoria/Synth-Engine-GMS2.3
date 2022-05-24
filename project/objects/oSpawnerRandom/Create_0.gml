///@desc Initialize Variables

/*
	A spawner with added random functionality
*/

// Set in creation code

offset = 0;			// Spawn timing offset (0 - 1)
rate = 50;			// Spawn rate in frames
rate_r = 0          // Added random rate
object = oApple;   // Object type to be spawned
xoffset = 0         // x offset at spawn
yoffset = 0         // y offset at spawn
hs = 0;				// Horizontal speed at spawn
vs = 0;				// Vertical speed at spawn
hs_r = 0;           // Added random hspeed
vs_r = 0;           // Added random vspeed
ahead = 0

// Do not set in creation code
adjusted = false
time = 0;
time_incr = 1 * global.fps_adjust;