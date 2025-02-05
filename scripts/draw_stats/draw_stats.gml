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
		
		button_gui(1 + i * (width + 1), 1, width, sep, buttons[i].label, -1, true, c_white, c_white, 0.25, 1, buttons[i].fn, BUTTON_ORIGIN.Left);
	}
	
	draw_text(0, 2 * sep,	$"{ GameInfo.name} made by { GameInfo.author}");
	draw_text(0, 3 * sep, $"version: { GameInfo.version[0]}.{ GameInfo.version[1]}.{ GameInfo.version[2]} { GameInfo.release}");
	draw_text(0, 4 * sep, $"{fps} fps");
	draw_text(0, 5 * sep, $"x: { player.x} y: { player.y}");
	draw_text(0, 6 * sep, $"cx: { Camera.x} cy: { Camera.y}");
	draw_text(0, 7 * sep, $"p: { ParticleCount } o: { instance_number(all) - ParticleCount }");
	draw_text(0, 8 * sep, $"axislh: { gamepad_axis_value(Gamepad, gp_axislh)} axislv: { gamepad_axis_value(Gamepad, gp_axislv)}");
	draw_text(0, 9 * sep, $"axisrh: { gamepad_axis_value(Gamepad, gp_axisrh)} axisrv: { gamepad_axis_value(Gamepad, gp_axisrv)}");
	draw_text(0, 10 * sep, $"controller: {Controller} | gpMenuIndex: {GamepadMenuIndex}");
	
}
