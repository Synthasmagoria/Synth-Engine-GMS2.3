///@desc Set setting strings
setting[0] = setting_get("fullscreen") ? "on" : "off"
setting[1] = setting_get("smoothing") ? "on" : "off"
setting[2] = string(setting_get("scale")) + "x"
setting[3] = string(setting_get("framerate"))
setting[4] = string(setting_get("music_volume"))
setting[5] = string(setting_get("effect_volume"))
setting[6] = setting_get("vsync") ? "on" : "off"
setting[7] = setting_get("gravity_control") ? "rotational" : "standard"
setting[8] = string(setting_get("input_delay"))