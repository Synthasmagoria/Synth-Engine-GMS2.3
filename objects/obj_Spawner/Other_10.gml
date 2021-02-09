///@desc Adjust values

adjusted = true;

// Adjust values for fps setting
rate /= global.fps_adjust;
hs *= global.fps_adjust;
vs *= global.fps_adjust;

// Set offset
time = rate * offset;
