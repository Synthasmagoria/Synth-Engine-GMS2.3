///@descr Destroy said objects

var instance;

for (var i = array_length_1d(object) - 1; i >= 0; i--) {
	
	instance = instance_place(x, y, object[i]);
	
	if (instance) {
		instance_destroy(instance);
	}
}