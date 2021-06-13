# Synth-Engine-GMS2.3

The main branch holds version v120
If you want the weapons system go to v120-weapons branch
There is a brach for v110 in case you want to go back
Pre 2.3 version (old assets and code, v097): https://github.com/Synthasmagoria/Synth-Engine-GMS2

 -- Saving something new in v120 --
All saved values are kept in the object oSaveData
It holds an array of keys that you can freely add and remove entries from
Once you've added a key to the array you can get and set it through the functions:
savedata_get(_active) and savedata_set(_active)
Or directly through referencing the object
oSaveData.save[?<key>] and oSaveData.save_active[?<key>]
	
All functions that interface with object oSaveData can be found in scrSaveData


 -- Saving something new in v110 --
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

Now you just need to define the behavior of the newly added variable in
whatever object will use it.
			     
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

v120:
- Separated audio from world
- Separated save variables from world
- Added custom weapons
- Removed event_user in favor of local functions
- vec2 struct has decent functionality now
- Lots more utility functions
- Added item and item display
- Changed to JSON saving
- Renamed some player variables and added frozen and stopped states
- A lot more
