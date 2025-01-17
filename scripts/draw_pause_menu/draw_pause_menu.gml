
enum PM_PAGE {
	None,
	Home,
	Settings,
}


function draw_pause_menu(){
	static pmPage = 0;
	
	if (keyboard_check_pressed(vk_escape)) {
		if (pmPage == 0) pmPage = 1; else pmPage = 0;
		Paused = !Paused;
	}
	
	
	// Style
	static panelWidth = 0;
	static panelHeight = 0;
	
	var xx, yy;
	xx = window_get_width() / 2;
	yy = window_get_height() / 2;
	
	var backgroundColor = $181818;
	var textColor = $F8F8F8;
	
	draw_set_alpha(0.95);
	rect(xx, yy, panelWidth, panelHeight, backgroundColor, false);
	draw_set_alpha(1);
	
	
	switch ( pmPage ) {
		case PM_PAGE.None:
			
			panelWidth = lerp(panelWidth, 0, 0.3);
			panelHeight = lerp(panelHeight, 0, 0.4);
			
			break;
		
		case PM_PAGE.Home:
			
			panelWidth = lerp(panelWidth, 400, 0.25);
			panelHeight = lerp(panelHeight, 600, 0.25);
			
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			
			draw_text(xx, yy - panelHeight/2.25, "Pause Menu");
			
			
			var buttons = [
				{
					label: "resume",
					fn: function(){
						Paused = false;
					}
				}
			];
			
			for (var i = 0; i < array_length(buttons); i++) {
				var sep = 36;
				
				button_gui(xx, yy + i * sep, panelWidth/1.1, sep, buttons[i].label, false, 0, c_ltgray, 0.5, buttons[i].fn(), BUTTON_ORIGIN.MiddleCenter);
			}
			
			
			break;
			
		case PM_PAGE.Settings:
			
			break;
	}
	
}
