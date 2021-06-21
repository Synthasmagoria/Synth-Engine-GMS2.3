// Set config file macros
#macro CONFIG_FILENAME "config.ini"
#macro CONFIG_SECTION_KEYBOARD "Keyboard"
#macro CONFIG_SECTION_GAMEPAD "Gamepad"
#macro CONFIG_SECTION_SETTINGS "Settings"

// Debug variables (set macro to false when releasing)
#macro DEBUG true
global.debug_nodeath = false

// Set game macros	
#macro GAME_WIDTH 800
#macro GAME_HEIGHT 608

// FPS macros
#macro FPS_BASE 50
#macro FPS_MULTIPLIER_CALCULATION FPS_BASE / global.setting[SETTING.FRAMERATE]
#macro FPS_MULTIPLIER_CALCULATION_SQUARED power(FPS_MULTIPLIER_CALCULATION, 2)