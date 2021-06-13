///@func globals_set_defaults()
///@desc sets default global variables
function globals_set_defaults() {
	global.button_default[BUTTON.RIGHT] = vk_right
	global.button_default[BUTTON.UP] = vk_up
	global.button_default[BUTTON.LEFT] = vk_left
	global.button_default[BUTTON.DOWN] = vk_down
	global.button_default[BUTTON.JUMP] = vk_shift
	global.button_default[BUTTON.SHOOT] = ord("Z")
	global.button_default[BUTTON.RETRY] = ord("R")
	global.button_default[BUTTON.PAUSE] = ord("P")
	global.button_default[BUTTON.SUICIDE] = ord("Q")
	
	global.button_menu[BUTTON_MENU.RIGHT] = vk_right
	global.button_menu[BUTTON_MENU.UP] = vk_up
	global.button_menu[BUTTON_MENU.LEFT] = vk_left
	global.button_menu[BUTTON_MENU.DOWN] = vk_down
	global.button_menu[BUTTON_MENU.ACCEPT] = vk_shift
	global.button_menu[BUTTON_MENU.DECLINE] = ord("Z")
	
	global.button_world[BUTTON_WORLD.MENU] = vk_f2
	global.button_world[BUTTON_WORLD.QUIT] = vk_escape
	global.button_world[BUTTON_WORLD.FULLSCREEN] = vk_f4
	global.button_world[BUTTON_WORLD.SCREENSHOT] = vk_f11
	
	global.setting_default[SETTING.FULLSCREEN] = false
	global.setting_default[SETTING.SMOOTHING] = false
	global.setting_default[SETTING.SCALE] = 1
	global.setting_default[SETTING.FRAMERATE] = 60
	global.setting_default[SETTING.MUSIC] = 1
	global.setting_default[SETTING.SOUND] = 0.6
	global.setting_default[SETTING.VSYNC] = true
	
	// Write default buttons & settings to config file if it doesn't exist
	if (!file_exists(CONFIG_FILENAME)) {
		
		ini_open(CONFIG_FILENAME)
		
		for (var i = 0; i < BUTTON.NUMBER; i++)
			ini_write_real(CONFIG_SECTION_BUTTONS, i, global.button_default[i])
			
		for (var i = 0; i < SETTING.NUMBER; i++)
			ini_write_real(CONFIG_SECTION_SETTINGS, i, global.setting_default[i])
		
		ini_close()
	}
	
	// Read buttons & settings from config
	global.button = array_create(BUTTON.NUMBER)
	global.setting = array_create(SETTING.NUMBER)
	
	ini_open(CONFIG_FILENAME)
	
	for (var i = 0; i < BUTTON.NUMBER; i++)
		global.button[i] = ini_read_real(CONFIG_SECTION_BUTTONS, i, 0)
	
	for (var i = 0; i < SETTING.NUMBER; i++)
		global.setting[i] = ini_read_real(CONFIG_SECTION_SETTINGS, i, 0)
		
	ini_close()
	
	// Set settings according to file or defaults
	for (var i = 0; i < SETTING.NUMBER; i++)
		setting_set(i, global.setting[i])
}

///@func globals_initialize()
///@desc called in oWorld at the start of the game
function globals_initialize() {
	// Randomize
	randomize()
	
	// Load sound effect audio group (audiogroup_default is for music)
	if (!audio_group_is_loaded(audiogroup_sound)) 
		audio_group_load(audiogroup_sound)
	
	// Set config file macros
	#macro CONFIG_FILENAME "config.ini"
	
	#macro CONFIG_SECTION_BUTTONS "B"
	#macro CONFIG_SECTION_SETTINGS "S"
	
	// Debug variables (set to false when releasing)
	#macro DEBUG true
	global.debug_nodeath = false
	global.debug_nodeath_button = vk_insert
	global.debug_save_button = vk_home
	global.debug_warp_button = vk_delete
	global.debug_text = "DEBUG"
	
	// Set game macros	
	#macro GAME_WIDTH 800
	#macro GAME_HEIGHT 608
	
	enum BUTTON { // Add to the enum to create new rebindable buttons
		RIGHT,
		UP,
		LEFT,
		DOWN,
		JUMP,
		SHOOT,
		RETRY,
		PAUSE,
		SUICIDE,
		NUMBER
	}
	
	enum BUTTON_MENU { // Buttons used to control the menu
		RIGHT,
		UP,
		LEFT,
		DOWN,
		ACCEPT,
		DECLINE,
		MENU,
		NUMBER
	}
	
	enum BUTTON_WORLD { // Used for fullscreening, returning to the menu etc.
		MENU,
		QUIT,
		FULLSCREEN,
		SCREENSHOT,
		NUMBER
	}
	
	enum SETTING { // Add settings here and specify what it does in setting_set
		FULLSCREEN,
		SMOOTHING,
		SCALE,
		FRAMERATE,
		MUSIC,
		SOUND,
		VSYNC,
		CONTROL_ROTATIONAL,
		NUMBER
	}
	
	// Default arrays
	global.button_default = array_create(BUTTON.NUMBER)
	global.button_menu = array_create(BUTTON_MENU.NUMBER)
	global.button_world = array_create(BUTTON_WORLD.NUMBER)
	global.setting_default = array_create(SETTING.NUMBER)
	
	// Game variables
	global.game_playing = false // variable to check if the game is not in the menu
	global.game_paused = false // variable to check if the game is paused
	window_set_caption("Synth Engine")
	
	// FPS macros
	#macro FPS_BASE 50
	#macro FPS_MULTIPLIER_CALCULATION FPS_BASE / global.setting[SETTING.FRAMERATE]
	#macro FPS_MULTIPLIER_CALCULATION_SQUARED power(FPS_MULTIPLIER_CALCULATION, 2)
	
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
}