switch menu_index {
	case MENU_SUB_KEYBOARD:
		input_mappings_save(INPUT_DEVICE.KEYBOARD)
		break
	case MENU_SUB_GAMEPAD:
		input_mappings_save(INPUT_DEVICE.GAMEPAD)
		break
}