

depth = 999999;

if (!Paused) depth = -9999999;

var player = get_player();
var xx = player.x;
var yy = player.y;

var size = 1;

if (instance_exists(Camera)) {
	size = Camera.size.width * Camera.zoom;
}

button(xx, yy, size, size, "", false, c_black, c_black, 0, function(){
	window_set_cursor(cr_default);
}, BUTTON_ORIGIN.MiddleCenter);
