///@desc Initialize Variables

// Make sure not to have multiple, nor to initialize twice
if (instance_number(object_index) > 1) {
	instance_destroy()
	exit
}

// Randomize
randomize()

// Reset variables
resetting_room = ""

// Pause variables
pause_surface = -1
pause_dim = 0.75

debug_text = "DEBUG"

// Set config file macros
#macro CONFIG_FILENAME "config.ini"
#macro CONFIG_SECTION_KEYBOARD "Keyboard"
#macro CONFIG_SECTION_GAMEPAD "Gamepad"
#macro CONFIG_SECTION_SETTINGS "Settings"

// Various
#macro DEBUG true
#macro GAME_WIDTH 800
#macro GAME_HEIGHT 608
#macro FPS_BASE 50

// Game variables
global.game_playing = false // variable that says when the game is not in the menu and not in a cutscene
global.game_paused = false // variable that says if the game is paused
global.game_running = false // variable that says when the game is not in the menu
window_set_caption("Synth Engine")

global.gamepad_slot = 0
global.debug_nodeath = false
global.menu_room = rMenu

// Player variables
global.player_depth = -1
global.player_blood_depth = -101
global.player_blood_part = part_type_create()
global.player_blood_part_life = 150
global.player_blood_part_speed = 5
global.player_blood_part_gravity = 0.125
part_type_sprite(global.player_blood_part, sBlood, false, false, true)
part_type_direction(global.player_blood_part, 0, 360, 0, 0)

global.player_blood_part_sys = part_system_create()
part_system_depth(global.player_blood_part_sys, -101)

// Essential instances (they add themselves to global scope)
global.input = noone
global.audio = noone
global.savedata = noone

instance_create_layer(0, 0, layer, oInput)
instance_create_layer(0, 0, layer, oAudio)
instance_create_layer(0, 0, layer, oSaveData)

global.settings = new setting_struct()
setting_read_all()
setting_apply_all()

// Done initializing
room_goto_next()