 ///@desc Prepare view and cam

// Variables
size = new vec2(GAME_WIDTH, GAME_HEIGHT)
area = {x : 0, y : 0, w : room_width - size.x, h : room_height - size.y}
target = oPlayer
active = false
index = 0

// Set up camera
camera = camera_create()

// Override this function in children if additional setup is needed
activate = function() {
	with (oCameraParent)
		active = false
		
	active = true
	camera_set_view_size(camera, size.x, size.y)
	view_set_camera(0, camera)
}

if instance_number(object_index) < 2
	activate()

// Room variables that cameras need to work
view_enabled = true
view_set_visible(0, true)