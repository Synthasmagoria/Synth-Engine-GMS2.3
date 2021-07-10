# Synth-Engine-GMS2.3
Assets that can be used to create fangames in GMS2.3

## Notes on engine versions: ##
tldr;

If you want to modify the player and don't know basic linear algebra go for v130.
Otherwise go for v140 (main)

v140:
	Adds 360 gravity, slopes and the weapon system.
	If you don't want to deal with the slightly more complicated player code I recommend you go for v130

v130:
	Adds controller support (also in v140)
	Doesn't have the weapons system but is mostly up to date otherwise

v120-weapons:
	As the name implies has the weapons system. You may bring it over to v130 if you want the code improvements and weapon system
	This version uses some outdated file i/o methods that may force you to write your own saving system if you
	want to save anything slightly complicated

v097 and older:
	This version of the engine works for GMS2 2.2 and earlier
	Uses very outdated methods for mostly everything
	But I used this to make Platform God and HTec, so it's not completely unusable

## Notes on the world object: ##
Instead of having a single world object taking care of music, saving, settings, etc.
it has been split into multiple different objects and scripts:

Previously it was like this:
objWorld + scripts for saving, music, settings / config etc.

Now it's like this:
oGame + scrGame

oAudio + scrAudio & scrRoomMusic

oSettings + scrSettings

oSaveData + scrSavedata

oInput + scrInput

If you want to change saving behavior, then modify oSaveData & scrSavedata
