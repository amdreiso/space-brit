


// Draw pause menu
var x0, y0;
x0 = window_get_width() / 2;
y0 = window_get_height() / 2;

var pmOffset = 1;

var pmButtons = [
	{
		label: "settings",
		fn: function() {
			if (mouse_check_button_pressed(mb_left)) {
				
			}
			window_set_cursor(cr_handpoint);
		}
	},
	{
		label: "resume",
		fn: function() {
			if (mouse_check_button_pressed(mb_left)) {
				set_pause(false);
			}
			window_set_cursor(cr_handpoint);
		}
	},
];


if (Paused) {
	
	draw_set_alpha(0.5);
	draw_rectangle_color(0, 0, window_get_width(), window_get_height(), c_black, c_black, c_black, c_black, false);
	draw_set_alpha(1);
	
	pm.width = lerp(pm.width, pm.setWidth, 0.25);
	pm.height = lerp(pm.height, pm.setHeight, 0.25);
	
	pm.alpha = lerp(pm.alpha, 1, 0.25);
	
} else {
	
	pm.alpha = lerp(pm.alpha, 0, 0.25);
	
}


if (pm.width > pmOffset && pm.height > pmOffset) {
	draw_set_alpha(pm.alpha);
	
	rect(x0, y0, pm.width, pm.height, pm.backgroundColor, false);
	rect(x0, y0, pm.width, pm.height, pm.outlineColor, true);
	
	for (var i = 0; i < array_length(pmButtons); i++) {
		var buttonHeight = 32;
		var buttonY = (y0 - pm.height / 3) + i * buttonHeight;
		
		if (!Paused) break;
		
		button_gui(
			x0, buttonY, pm.width, buttonHeight, 
			pmButtons[i].label, false, 0, c_ltgray, 0.2, pm.alpha,
			pmButtons[i].fn(), BUTTON_ORIGIN.MiddleCenter
		);
	}
	
	draw_set_alpha(1);
}




// Debug
draw_stats();


