
depth = 999999;

var player = get_player();
var xx = player.x;
var yy = player.y;

button(xx, yy, 1000, 1000, "", false, c_black, c_black, 0, function(){
	window_set_cursor(cr_default);
}, BUTTON_ORIGIN.MiddleCenter);
