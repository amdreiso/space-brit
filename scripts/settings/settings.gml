function settings(){
	globalvar Settings;
	Settings = {}
	
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
	}
	
	
	// Load save settings
	if (file_exists(SETTINGS_SF)) {
		var buffer = buffer_load(SETTINGS_SF);
		var content = buffer_read(buffer, buffer_text);
		buffer_delete(buffer);
		
		Settings = json_parse(content);
	}
	
	
	// Apply changes after load
	layer_enable_fx("Glowing_Particles", Settings.glowEffect);
}