function draw_stats(){

	if (!Debug) return;

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	var player;
	
	switch (room) {
		case rmOuterSpace:
			player = Spaceship;
			break;
			
		case rmPlanet:
			player = Player;
			break;
	}
	
	var sep = 14;
	
	var buttons = [
		{
			label: "exit",
			fn: function(){
				if (mouse_check_button_pressed(mb_left)) {
					game_end();
				}
		
				window_set_cursor(cr_handpoint);
			},
		},
		{
			label: "reset",
			fn: function(){
				if (mouse_check_button_pressed(mb_left)) {
					game_restart();
				}
		
				window_set_cursor(cr_handpoint);
			},
		},
	];
	
	for (var i = 0; i < array_length(buttons); i++) {
		var prev = 0;
		if (i < array_length(buttons)-1) prev = 1;
		
		var width = 75;
		
		button_gui(1 + i * (width + 1), 1, width, sep, buttons[i].label, true, c_white, c_white, 0.25, buttons[i].fn, BUTTON_ORIGIN.Left);
	}
	
	draw_text(0, 2 * sep,	$"{ GameInfo.name } made by { GameInfo.author }");
	draw_text(0, 3 * sep, $"version: { GameInfo.version[0] }.{ GameInfo.version[1] }.{ GameInfo.version[2] } { GameInfo.release }");
	draw_text(0, 4 * sep, $"{fps} fps");
	draw_text(0, 5 * sep, $"x: { player.x } y: { player.y }");
	
	
}