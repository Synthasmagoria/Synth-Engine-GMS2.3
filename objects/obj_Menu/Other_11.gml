///@desc Set setting strings
setting[0] = g.setting[SETTING.FULLSCREEN] ? "on" : "off";
setting[1] = g.setting[SETTING.SMOOTHING] ? "on" : "off";
setting[2] = string(g.setting[SETTING.SCALE]) + "x";
setting[3] = string(g.setting[SETTING.FRAMERATE]);
setting[4] = string(g.setting[SETTING.MUSIC]);
setting[5] = string(g.setting[SETTING.SOUND]);
setting[6] = g.setting[SETTING.VSYNC] ? "on" : "off";