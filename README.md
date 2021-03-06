# Synth-Engine-GMS2.3
Before you download!

If you're here for the 360 gravity then download the engine from the 'omnigrav' branch
The version on the main branch doesn't have 360 gravity (but familiar player code)

Pre 2.3 version (old assets): https://github.com/Synthasmagoria/Synth-Engine-GMS2

 -- Saving something new --
All saved values in this engine are based on enums defined in the create event of obj_World.
To add more saved values you can add entries to the end of the enums before the 'NUMBER' entry.

e.g.
enum SAVE {
	X,
	Y,
	ROOM,
	DEATH,
	TIME,
	FLAG,
	USERNAME,	<---
	NUMBER
}

Remember to specify whether the new saved value is a string or not.w
Index the arrays that are linked to saved values with the enum entry.

e.g.
global.save_as_string[SAVE.USERNAME] = true;

Now you just need to define the behavior of the newly added button in
whatever object will use it. And don't forget to make it remappable in
your custom menu ;)
To get a better understanding of how this works you can take a look at the
script called scr_SavedataFunctions

To add new buttons and settings you can use the same procedure just without
the string step.

Further comments on how the code works can be found in the scripts themselves.
Don't forget to use the manual by pressing F1.
Contact me on discord if you need further help Synthasmagoria#6751


Changelog v097 (doesn't cover everything):
- Added toggleable vsync
- Added outside warp
- Added mask rainbow
- Added better coded cameras
- Added utility scripts
- Changed pause surface
- Changed screenshot image naming
- Added a new default tileset
- All custom functions now have snake case names and no prefix
	e.g. scr_PlayerJump -> player_jump
- Blood is now a particle system and not an object using cpu drawing functions
- Tried making saving functions more straightforward
- Set global.save_number to 5
- Added string saving functionality, use global.save_as_string
- Rooms as now saved as strings
- Pause surface now gets freed from memory
- Formatted all scripts to the new GMS2.3 format
- Gave player sounds player prefix
- objCameraTrigger

v100:
- Removed audiogroup macros
- Fixed a bug that involved unnecessarily setting the window size when going out of fullscreen
- Removed unnecessary parameter in player_jump
- Added vines
- Changed the way the player's maximum speed is handled
- Secondary jumps now referred to as 'airjumps'
- Water1 now refreshes airjumps (oops)

v110:
- Added omnidirection gravity and vector speed stuff in obj_Player
- Room music pitch and gain scripts
- Gravity control setting
- Old school left/right control for walking
- Vines
- Removed old tiles
