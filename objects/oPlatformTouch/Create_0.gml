///@desc Initialize

event_inherited()

touched = false
hs = 0
vs = 0

touch = function() {
	if (!touched) {
		touched = true
		hspeed = hs * global.fps_adjust
		vspeed = vs * global.fps_adjust
	}
}