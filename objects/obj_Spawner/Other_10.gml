///@desc Adjust values

adjusted = true;

// Adjust values for fps setting
rate /= global.fps_calculation;
hs *= global.fps_calculation;
vs *= global.fps_calculation;

// Set offset
time = rate * offset;
