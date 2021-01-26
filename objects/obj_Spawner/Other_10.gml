///@desc Adjust values

adjusted = true;

// Adjust values for fps setting
rate /= g.fps_adjust;
hs *= g.fps_adjust;
vs *= g.fps_adjust;

// Set offset
time = rate * offset;
