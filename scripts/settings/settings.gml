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
	}
}