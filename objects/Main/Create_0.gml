

// Game Information
globalvar GameInfo;
GameInfo = {
	name: "Space Colonizer Simulator",
	version: [0, 0, 0],
	release: "indev",
	author: "Andrei Scatolin",
};


// Main Scripts
fovy();
settings();


// Globals
globalvar GameSpeed; GameSpeed = 1;
globalvar Paused; Paused = false;
globalvar Debug; Debug = false;
globalvar Seed; Seed = 0;
globalvar StarGrid; StarGrid = ds_map_create();
globalvar Stars; Stars = {
	chunk: 128,
}

globalvar ParticleCount; ParticleCount = 0;

globalvar Volume;
Volume = {
	music: 1.0,
	effects: 1.0,
}

globalvar Sound; Sound = {};

Sound.distance = 20;
Sound.dropoff	= 5;
Sound.multiplier = 1;

audio_falloff_set_model(audio_falloff_inverse_distance);
audio_listener_orientation(0, 1, 0, 0, 0, 1);



// Gameplay
player = instance_create_layer(0, 0, "Spaceship", Spaceship);
instance_create_layer(0, 0, "Spaceship", Music);
instance_create_layer(0, 0, "Spaceship", OuterSpace);
instance_create_layer(0, 0, "Spaceship", PlanetHandler);
instance_create_layer(0, 0, "Spaceship", CursorHandler);

layer_enable_fx("Glowing_Particles", false);

repeat (50) {
	var xx, yy;
	var range = new vec2(2000, 1250);
	
	xx = player.x + irandom_range(-range.x, range.x);
	yy = player.y + irandom_range(-range.y, range.y);
	
	var obj = instance_create_layer(
		xx,
		yy,
		"Stars",
		Particle
	);
	
	with (obj) {
		self.depthFactor = (get_perlin_noise_2D(obj.x, obj.y, 1) + 1) / 50;

		self.sprite_index = sStars_particle;
		self.image_speed = 0;
		self.image_index = get_perlin_noise_2D(obj.x, obj.y, 2, true);
		
		self.scale = get_perlin_noise_2D(obj.x, obj.y, 0.08) / 1.5;
		
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



// For testing
Debug = true;

