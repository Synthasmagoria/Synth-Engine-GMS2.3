# Synth-Engine-GMS2.3
Assets that can be used to create fangames in GMS2.3
v097

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
