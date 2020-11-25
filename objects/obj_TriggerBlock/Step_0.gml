///@desc Move

pos = clamp(pos + dir * spd, 0, 1);
x = xx + hm * pos;
y = yy + vm * pos;
