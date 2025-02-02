function settings(){
	globalvar Settings;
	Settings = {}
	
	// Default Settings
	with (Settings) {
		// Audio
		volume = {
			master: 1.0,
			music: 1.0,
			effects: 1.0,
		}
		
		// Instances
		maxParticlesOnScreen = 1000;
		glowEffect = false;
		
		// Translation
		language = LANGUAGE.English;
		
		gamepad = {
			deadzone: 0.00,
		}
	}
	
	
	// Load save settings
	if (file_exists(SETTINGS_SF)) {
		var buffer = buffer_load(SETTINGS_SF);
		var content = buffer_read(buffer, buffer_text);
		buffer_delete(buffer);
		
		
		// Set values from save file
		var loadedSettings = json_parse(content);
		var names = struct_get_names(loadedSettings);
		
		for (var i = 0; i < array_length(names); i++) {
			var val = variable_struct_get(loadedSettings, names[i]);
			struct_set(Settings, names[i], val);
		}
	}
	
	
	/// Apply changes after load
	
	// Toggle glow effect
	layer_enable_fx("Glowing_Particles", Settings.glowEffect);
	
	// Set gamepad deadzone
	if (gamepad_is_connected(Gamepad))
		gamepad_set_axis_deadzone(Gamepad, Settings.gamepad.deadzone);
	
	
	show_debug_message(json_stringify(Settings, true));
}