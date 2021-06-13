///@desc

time = frac(time + f2sec(1)) * animate
y = ystart + animcurve_channel_evaluate(animcurve_get(aSinewave).channels[0], time) * wobble