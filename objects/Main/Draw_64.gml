


// Draw pause menu
var x0, y0;
x0 = window_get_width() / 2;
y0 = window_get_height() / 2;

var pmOffset = 1;

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


if (pm.width > pmOffset && pm.height > pmOffset && pm.alpha > 0.05) {
	draw_set_alpha(pm.alpha);
	
	rect(x0, y0, pm.width, pm.height, pm.backgroundColor, false);
	rect(x0, y0, pm.width, pm.height, pm.outlineColor, true);
	
	var xx = window_get_width() / 2;
	var yy = window_get_height() / 2;
	
	var buttonWidth = pm.width / 1.5;
	var buttonHeight = 28;
	var buttonSep = 28 * 1.25;
	var checkboxSize = 15;
	
	var top = (yy - pm.height / 2) + 50;
	
	switch (pm.page) {
		
		case PM_PAGE.Home:
			
			button_gui(
				xx, top, buttonWidth, buttonHeight,
				"Settings", true, $181818, c_ltgray, 0.10, pm.alpha,
				function(){
					if (mouse_check_button_pressed(mb_left)) {
						pm.page = PM_PAGE.Settings;
					}
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			button_gui(
				xx, top + 1 * buttonSep, buttonWidth, buttonHeight,
				"Resume", true, $181818, c_ltgray, 0.10, pm.alpha,
				function(){
					if (mouse_check_button_pressed(mb_left)) {
						Paused = false;
					}
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			break;
		
		case PM_PAGE.Settings:
			
			button_gui(
				xx, top, buttonWidth, buttonHeight,
				"Go back", true, $181818, c_ltgray, 0.10, pm.alpha,
				function(){
					if (mouse_check_button_pressed(mb_left)) {
						pm.page = PM_PAGE.Home;
					}
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			
			// Settings
			var x2 = (xx - pm.width / 2) + 25;
			
			button_gui(
				x2, top + buttonSep, checkboxSize, checkboxSize,
				"", true, $181818, c_ltgray, 0.10, pm.alpha,
				function(){
					if (mouse_check_button_pressed(mb_left)) {
						var str = "Glowing_Particles";
						
						layer_enable_fx(
							str, 
							!layer_fx_is_enabled(str)
						);
					}
				}, BUTTON_ORIGIN.MiddleCenter
			);
			draw_text(x2 + checkboxSize * 2, top + buttonSep, "Toggle glow effect");
			
			
			
			
			
			
			break;
		
	}
	
	
	draw_set_alpha(1);
}




// Debug
draw_stats();


