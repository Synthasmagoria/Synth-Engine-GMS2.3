 ///@desc Prepare view and cam

// Variables
size = new vec2(GAME_WIDTH, GAME_HEIGHT);
area = new rect2d(0, 0, room_width - size.x, room_height - size.y);
target = obj_Player;
active = false;
index = 0;

// Set up camera
camera = camera_create();

// Override this function in children if additional setup is needed
activate = function() {
	with (obj_CameraParent)
		active = false;
		
	active = true;
	camera_set_view_size(camera, size.x, size.y);
	view_set_camera(0, camera);
}

// Room variables that cameras need to work
view_enabled = true;
view_set_visible(0, true);

// Activate camera automatically if only one in the room
if (instance_number(obj_CameraParent) == 1)
	activate()