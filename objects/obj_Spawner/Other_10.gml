///@desc Adjust values

adjusted = true;

// Adjust values for fps setting
rate /= g.fps_calculation;
hs *= g.fps_calculation;
vs *= g.fps_calculation;

// Set offset
time = rate * offset;
