

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


// Globals
globalvar GameSpeed; GameSpeed = 1;
globalvar Paused; Paused = false;
globalvar Debug; Debug = false;
globalvar Seed; Seed = 0;
globalvar StarGrid; StarGrid = ds_map_create();
globalvar Stars; Stars = {
	chunk: 128,
}

globalvar Volume;
Volume = {
	music: 1.0,
	effects: 1.0,
}


// Gameplay
player = instance_create_layer(0, 0, "Spaceship", Spaceship);
instance_create_layer(0, 0, "Spaceship", Music);


repeat (1000) {
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
		self.depthFactor = (get_perlin_noise_2D(obj.x, obj.y, 1) + 1) / 10;

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
	}
}


// For testing
Debug = true;

