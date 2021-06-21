///@desc Initialize Variables

// Make sure not to have multiple, nor to initialize twice
if (instance_number(object_index) > 1) {
	instance_destroy()
	exit
}

// Reset variables
resetting_room = ""

// Pause variables
pause_surface = -1
pause_dim = 0.75

debug_text = "DEBUG"

// Game variables
global.game_playing = false // variable that says when the game is not in the menu and not in a cutscene
global.game_paused = false // variable that says if the game is paused
global.game_running = false // variable that says when the game is not in the menu
window_set_caption("Synth Engine")

global.gamepad_slot = 0
global.debug_nodeath = false

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

// Essential instances
global.audio = instance_create_layer(0, 0, layer, oAudio)
global.input = instance_create_layer(0, 0, layer, oInput)
global.savedata = instance_create_layer(0, 0, layer, oSaveData)

global.input.initialize()
savedata_set_defaults()

#region Settings
enum SETTING {
	FULLSCREEN,
	SMOOTHING,
	SCALE,
	FRAMERATE,
	MUSIC,
	SOUND,
	VSYNC,
	CONTROL_ROTATIONAL,
	INPUT_DELAY,
	NUMBER
}

global.setting_default = array_create(SETTING.NUMBER)
global.setting_default[SETTING.FULLSCREEN] = false
global.setting_default[SETTING.SMOOTHING] = false
global.setting_default[SETTING.SCALE] = 1
global.setting_default[SETTING.FRAMERATE] = 60
global.setting_default[SETTING.MUSIC] = 1.0
global.setting_default[SETTING.SOUND] = 0.8
global.setting_default[SETTING.VSYNC] = true

if (!config_section_exists(CONFIG_SECTION_SETTINGS)) {
	ini_open(CONFIG_FILENAME)
	for (var i = 0; i < SETTING.NUMBER; i++)
		ini_write_real(CONFIG_SECTION_SETTINGS, i, global.setting_default[i])
	ini_close()
}

// Read settings from config
global.setting = array_create(SETTING.NUMBER)

ini_open(CONFIG_FILENAME)
for (var i = 0; i < SETTING.NUMBER; i++)
	global.setting[i] = ini_read_real(CONFIG_SECTION_SETTINGS, i, global.setting_default[i])
ini_close()

// Set settings according to file or defaults (depends on some previously defined globals)
for (var i = 0; i < SETTING.NUMBER; i++)
	config_setting_set(i, global.setting[i])
#endregion

// Done initializing
room_goto_next()