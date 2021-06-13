///@desc Initialize Variables

// Make sure not to have multiple, nor to initialize twice
if (instance_number(object_index) > 1) {
	instance_destroy()
	exit
}

// Initialize the globals
globals_initialize()

globals_set_defaults()

// Reset variables
resetting_room = ""

// Pause variables
pause_surface = -1
pause_dim = 0.75

// Done initializing
room_goto_next()