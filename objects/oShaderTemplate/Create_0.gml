///@desc Vars

sh = shTemplate
time = 0
time_incr = f2sec(1)

pass_uniforms = function() {
	shader_set_uniform_f(shader_get_uniform(sh, "time"), time)
}