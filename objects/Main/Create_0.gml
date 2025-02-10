

// Game Information
globalvar GameInfo;
GameInfo = {
	name: "Space Colonizer Simulator",
	version: [0, 0, 0],
	release: "indev",
	author: "Andrei Scatolin",
};



// Globals
globalvar GameSpeed; GameSpeed = 1;
globalvar GameSeed; GameSeed = irandom_range(999999, 99999999999);
globalvar Paused; Paused = false;
globalvar Debug; Debug = false;
globalvar Seed; Seed = 2358327;
globalvar Console; Console = false;

globalvar ParticleCount; ParticleCount = 0;


// Gamepad
globalvar Gamepad; Gamepad = 0;
globalvar GamepadWasFound; GamepadWasFound = "not found";
globalvar GamepadMenuIndex; GamepadMenuIndex = 0;

globalvar Controller; Controller = CONTROLLER.Keyboard;

globalvar Keymap; Keymap = get_keymap();



// Audio
globalvar Sound; Sound = {};

Sound.distance = 20;
Sound.dropoff	= 5;
Sound.multiplier = 1;

audio_falloff_set_model(audio_falloff_inverse_distance);
audio_listener_orientation(0, 1, 0, 0, 0, 1);



// Main Scripts
randomize();

fovy();
load_macros();

item_data();
planet_data();
tile_data();
translation_data();
command_data();

get_keymap();

settings();



// Gameplay
player = instance_create_layer(10000, 13000, "Spaceship", Spaceship);
instance_create_layer(10000, 12800, "Spaceship", eBomber);
instance_create_layer(10000, 12800, "Spaceship", eBomber);
instance_create_layer(10000, 12800, "Spaceship", eBomber);
instance_create_layer(10000, 12800, "Spaceship", eBomber);
instance_create_layer(10000, 12800, "Spaceship", eBomber);
instance_create_layer(10000, 13000, "Spaceship", Camera);
instance_create_layer(0, 0, "Spaceship", MusicHandler);
instance_create_layer(0, 0, "Spaceship", OuterSpace);
instance_create_layer(0, 0, "Spaceship", PlanetHandler);
instance_create_layer(0, 0, "Spaceship", CursorHandler);
instance_create_layer(0, 0, "Spaceship", Player);
instance_create_layer(0, 0, "Spaceship", Cursor);

instance_create_layer(irandom(room_width)/2, irandom(room_height)/2, "Solar_System", SolarSystem);


repeat (50) {
	var xx, yy;
	var range = vec2(2000, 1250);
	
	xx = player.x + irandom_range(-range.x, range.x);
	yy = player.y + irandom_range(-range.y, range.y);
	
	var obj = instance_create_layer(
		xx,
		yy,
		"Stars",
		Particle
	);
	
	with (obj) {
		self.depthFactor = (random(1.00) + 1) / 50;

		self.sprite_index = sStars_particle;
		self.image_speed = 0;
		self.image_index = irandom(2);
		
		self.scale = random(2.5) * 1.5;
		
		var val = self.depthFactor + 0.25;
		var starRGB = choose(
			new rgb(220, 220, 220),
			new rgb(244, 244, 200),
			new rgb(210, 210, 237),
			new rgb(200, 200, 200),
		);
		
		self.color = make_color_rgb(
			starRGB.r / val,
			starRGB.g / val,
			starRGB.b / val
		);
		
		self.step = 0;
		self.destroyTime = 0;
		
		self.update = function() {
			if (point_distance_3d(x, 0, 0, Spaceship.x, 0, 0) > 500) {
			}
		}
	}
}



// Gamepad
findGamepad = function() {
	for (var i = 0; i < gamepad_get_device_count(); i++) {
		if (gamepad_is_connected(i)) {
			Gamepad = i;
			GamepadWasFound = "found!";
			
			Keymap = get_keymap();
			
			show_debug_message($"Device {i} was connected as a gamepad!");
			
			return;
		}
	}
	
	show_debug_message("Could not connect gamepad");
}

alarm[0] = 3;



// Pause menu
enum PM_PAGE {
	Home,
	Settings,
	AudioSettings,
	DeviceSettings,
}

pauseMenu = {
	page: PM_PAGE.Home,
	
	width: 500,
	height: 600,
	setWidth: 500,
	setHeight: 600,
	
	alpha: 0,
	
	backgroundColor: $FF080808,
	outlineColor: $FF181818,
}

saveSettings = function() {
	save_id(SETTINGS_SF, Settings, true);
}


drawPauseMenu = function() {
	var x0, y0;
	x0 = window_get_width() / 2;
	y0 = window_get_height() / 2;

	var pmOffset = 1;

	if (Paused) {
	
		draw_set_alpha(0.5);
		draw_rectangle_color(0, 0, window_get_width(), window_get_height(), c_black, c_black, c_black, c_black, false);
		draw_set_alpha(1);
	
		pauseMenu.width = lerp(pauseMenu.width, pauseMenu.setWidth, 0.25);
		pauseMenu.height = lerp(pauseMenu.height, pauseMenu.setHeight, 0.25);
	
		pauseMenu.alpha = lerp(pauseMenu.alpha, 1, 0.25);
	
	} else {
	
		pauseMenu.alpha = lerp(pauseMenu.alpha, 0, 0.25);
	
	}

	if (pauseMenu.width > pmOffset && pauseMenu.height > pmOffset && pauseMenu.alpha > 0.05) {
		draw_set_alpha(pauseMenu.alpha);
	
		rect(x0, y0, pauseMenu.width, pauseMenu.height, pauseMenu.backgroundColor, false, pauseMenu.alpha);
		rect(x0, y0, pauseMenu.width, pauseMenu.height, pauseMenu.outlineColor, true, pauseMenu.alpha);
	
		var xx = window_get_width() / 2;
		var yy = window_get_height() / 2;
	
		var buttonWidth = pauseMenu.width / 1.5;
		var buttonHeight = 28;
		var buttonSep = 28 * 1.25;
		var checkboxSize = 22;
		var sliderOffset = (pauseMenu.width / 2) - (buttonHeight * 2) - 2;
		var sliderOffset2 = (pauseMenu.width / 2) - buttonHeight;
	
		var top = (yy - pauseMenu.height / 2) + 50;
	
	
		switch (pauseMenu.page) {
		
			case PM_PAGE.Home:
				
				// Set button ids for gamepad
				gp_menu(0, 1);
				
				// Paused header
				draw_set_halign(fa_center);
				draw_text(xx, top - 14, ts(13));
	
				button_gui(
					xx, top + buttonSep, buttonWidth, buttonHeight,
					ts(5), 0, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.select) {
							pauseMenu.page = PM_PAGE.Settings;
							GamepadMenuIndex = 0;
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				button_gui(
					xx, top + 2 * buttonSep, buttonWidth, buttonHeight,
					ts(14), 1, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.select) {
							set_pause(false);
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				break;
		
			case PM_PAGE.Settings:
				
				gp_menu(0, 8);
				
				button_gui(
					xx, top, buttonWidth, buttonHeight,
					ts(9), 0, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.select) {
							pauseMenu.page = PM_PAGE.Home;
							GamepadMenuIndex = 0;
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
			
				// Settings
				var x2 = (xx);
			
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
			
			
				// Audio settings
				button_gui(
					xx, top + 2 * buttonSep, buttonWidth, buttonHeight, ts(12), 1,
					true, $181818, c_ltgray, 0.1, pauseMenu.alpha, function(){
						if (Keymap.select) {
							pauseMenu.page = PM_PAGE.AudioSettings;
							GamepadMenuIndex = 0;
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
				
				
				// GLOW EFFECT
				button_gui(
					x2, top + 3 * buttonSep, buttonWidth, buttonHeight,
					ts(11)+": "+str_bool(layer_fx_is_enabled("Glowing_Particles")), 2, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.select) {
							var str = "Glowing_Particles";
							
							layer_enable_fx(
								str, 
								!layer_fx_is_enabled(str)
							);
							
							Settings.glowEffect = layer_fx_is_enabled(str);
							
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
				
				
				// Language Selector
				button_gui(
					x2, top + 4 * buttonSep, buttonWidth, buttonHeight,
					ts(19)+": "+ts(0), 3, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.select) {
							Settings.language ++;
							if (Settings.language >= LANGUAGE.Count) Settings.language = 0;
							
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
				
				// Device Settings
				button_gui(
					x2, top + 5 * buttonSep, buttonWidth, buttonHeight,
					ts(20), 4, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.select) {
							pauseMenu.page = PM_PAGE.DeviceSettings;
							GamepadMenuIndex = 0;
							
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
				
				#region AMOUNT OF PARTICLES
				
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
				
				draw_text_color(xx, top + 6 * buttonSep, ts(18)+": "+string(Settings.maxParticlesOnScreen), c_white, c_white, c_white, c_white, pauseMenu.alpha);
				
				button_gui(
					xx - sliderOffset, top + 6 * buttonSep, buttonHeight, buttonHeight,
					"<", 6, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.maxParticlesOnScreen > 0) {
							Settings.maxParticlesOnScreen --;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				button_gui(
					xx + sliderOffset, top + 6 * buttonSep, buttonHeight, buttonHeight,
					">", 7, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.maxParticlesOnScreen < 5000) {
							Settings.maxParticlesOnScreen ++;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
				
				button_gui(	
					xx - sliderOffset2, top + 6 * buttonSep, buttonHeight, buttonHeight,
					"<<", 5, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.maxParticlesOnScreen > 5) {
							Settings.maxParticlesOnScreen -= 5;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				button_gui(
					xx + sliderOffset2, top + 6 * buttonSep, buttonHeight, buttonHeight,
					">>", 8, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.maxParticlesOnScreen < 4995) {
							Settings.maxParticlesOnScreen += 5;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				#endregion
			
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
			
			
			
				break;
		
			case PM_PAGE.AudioSettings:
				
				gp_menu(0, 6);
				
				button_gui(
					xx, top, buttonWidth, buttonHeight,
					ts(9), 0, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.select) {
							pauseMenu.page = PM_PAGE.Settings;
							GamepadMenuIndex = 0;
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
			
				// Master
				button_gui(
					xx - sliderOffset, top + 2 * buttonSep, buttonHeight, buttonHeight,
					"<", 1, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.volume.master > 0) {
							Settings.volume.master -= 0.01;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				button_gui(
					xx + sliderOffset, top + 2 * buttonSep, buttonHeight, buttonHeight,
					">", 2, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.volume.master < 1) {
							Settings.volume.master += 0.01;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				draw_set_halign(fa_center);
				draw_text_color(xx, top + 2 * buttonSep, ts(15)+": "+string(Settings.volume.master * 100), c_white, c_white, c_white, c_white, pauseMenu.alpha);
			
			
				// Music
				button_gui(
					xx - sliderOffset, top + 3 * buttonSep, buttonHeight, buttonHeight,
					"<", 3, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.volume.music > 0) {
							Settings.volume.music -= 0.01;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				button_gui(
					xx + sliderOffset, top + 3 * buttonSep, buttonHeight, buttonHeight,
					">", 4, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.volume.music < 1) {
							Settings.volume.music += 0.01;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				draw_set_halign(fa_center);
			
				draw_text_color(xx, top + 3 * buttonSep, ts(16)+": "+string(Settings.volume.music * 100), c_white, c_white, c_white, c_white, pauseMenu.alpha);
			
			
				// Effects
				button_gui(
					xx - sliderOffset, top + 4 * buttonSep, buttonHeight, buttonHeight,
					"<", 5, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.volume.effects > 0.01) {
							Settings.volume.effects -= 0.01;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				button_gui(
					xx + sliderOffset, top + 4 * buttonSep, buttonHeight, buttonHeight,
					">", 6, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.volume.effects < 1) {
							Settings.volume.effects += 0.01;
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				draw_set_halign(fa_center);
			
				draw_text_color(xx, top + 4 * buttonSep, ts(17)+": "+string(Settings.volume.effects * 100), c_white, c_white, c_white, c_white, pauseMenu.alpha);
			
				draw_set_halign(fa_left);
			
			
				break;
		
			case PM_PAGE.DeviceSettings:
				
				gp_menu(0, 3);
				
				button_gui(
					xx, top, buttonWidth, buttonHeight,
					ts(9), 0, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.select) {
							pauseMenu.page = PM_PAGE.Settings;
							GamepadMenuIndex = 0;
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
			
				// Find Gamepad
				button_gui(
					xx, top + 2 * buttonSep, buttonWidth, buttonHeight,
					ts(21) + ": " + GamepadWasFound, 1, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.select) {
							findGamepad();
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
				
				
				// Set gamepad deadzone
				button_gui(
					xx - sliderOffset, top + 3 * buttonSep, buttonHeight, buttonHeight,
					"<", 2, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.gamepad.deadzone > 0) {
							Settings.gamepad.deadzone -= 0.005;
							gamepad_set_axis_deadzone(Gamepad, Settings.gamepad.deadzone);
							
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
			
				button_gui(
					xx + sliderOffset, top + 3 * buttonSep, buttonHeight, buttonHeight,
					">", 3, true, $181818, c_ltgray, 0.10, pauseMenu.alpha,
					function(){
						if (Keymap.selectHeld && Settings.gamepad.deadzone < 1) {
							Settings.gamepad.deadzone += 0.005;
							gamepad_set_axis_deadzone(Gamepad, Settings.gamepad.deadzone);
						
							saveSettings();
						}
						window_set_cursor(cr_handpoint);
					}, BUTTON_ORIGIN.MiddleCenter
				);
				
				draw_set_halign(fa_center);
				draw_text_color(xx, top + 3 * buttonSep, ts(22)+": "+string(Settings.gamepad.deadzone), c_white, c_white, c_white, c_white, pauseMenu.alpha);
			
				break;
				
		}
	
		draw_set_alpha(1);
	}
}


// Debugging
Debug = true;

logs = [];
logRewind = -1;

runCommand = function(input, showHistory = false) {
	if (input == "") return;
	
	var args = string_split(input, " ", true);
	array_delete(args, 0, 1);
	
	var found = false;
	
	if (showHistory)
		log("- "+input);
	
	// Run Actual Command
	for (var i = 0; i < array_length(CommandData); i++) {
		if (string_starts_with(string_lower(input), CommandData[i].name)) {
			var argc = CommandData[i].argc;
			var argl = array_length(args);
			
			if (argc != argl) {
				log($"Missing arguments.");
				return;
			}
			
			CommandData[i].fn(args);
			found = true;
		}
	}
	
	if (!found) {
		log("Invalid command!");
	}
}

drawConsole = function() {
	if (!Console) return;
	
	var input = keyboard_string;
	
	if (keyboard_check_pressed(vk_enter)) {
		runCommand(input, true);
		keyboard_string = "";
	}
	
	// Draw the actual console
	var width = 700;
	var height = 400;
	var c0 = $080808;
	var c1 = c_gray;
	
	draw_set_alpha(0.99);
	
	draw_rectangle_color(
		window_get_width() - width, 200, window_get_width(), 200 + height, 
		c0, c0, c0, c0, false
	);
	
	draw_set_alpha(1);
	
	draw_rectangle_color(
		window_get_width() - width, 200, window_get_width(), 200 + height, 
		c1, c1, c1, c1, true
	);
	
	draw_set_halign(fa_left);
	
	// Draw logs
	for (var i = 0; i < array_length(logs); i++) {
		var sep = 14;
	
		draw_set_font(logs[i].font);
		
		draw_text_color(window_get_width() - width + 5, (150 + height) - i * sep, logs[i].str, logs[i].color, logs[i].color, logs[i].color, logs[i].color, 1);
	}
	
	draw_set_font(fnt_console);
		
	draw_text(window_get_width() - width + 5, 180 + height, "> " + input);
	
	draw_set_font(fnt_main);
	draw_set_halign(fa_center);
	
	var scale = 0.10;
	var yy = 201;
	
	// KITTIESSSS
	draw_sprite_ext(sKitty, 0, window_get_width(), yy + height, scale, scale, 0, c_white, 1);
	draw_sprite_ext(sKitty3, 0, window_get_width() - (sprite_get_width(sKitty) * scale), yy + height, scale, scale, 0, c_white, 1);
	draw_sprite_ext(sKitty2_1, 0, window_get_width() - (sprite_get_width(sKitty3) * scale), yy + height, scale, scale, 0, c_white, 1);
}

runCommand("start");


//set_planet(instance_nearest(x, y, Planet).components);


