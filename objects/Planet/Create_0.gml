
sprite_index = choose(
	sPlanetArid1,
	sPlanetRocky1,
	sPlanetRocky2,
);


sun = -1;						// Center of solar system
distanceToSun = 0;

orbitSpeed = 0.0002;

setAngle = false;
angle = irandom(360);

orbit = function() {
	if (sun == -1) return;
	
	angle += (orbitSpeed / (distanceToSun / 5)) * GameSpeed;
	
	if (angle >= 360) {
		angle = 0;
	}
	
	x = sun.x + lengthdir_x(distanceToSun, angle);
	y = sun.y + lengthdir_y(distanceToSun, angle);
	
	if (!setAngle) {
		angle = irandom(360);
		setAngle = true;
	}
}


// Planet variables
components = {
	
	//type: irandom(PLANET_TYPE.Count - 1),
	type: 0,
	
	resources: {
		water:						random(1) / irandom(20),
		stone:						random(1),
		iron:							random(1),
		copper:						random(1),
		gold:							random(1),
		silver:						random(1),
	},
	
	generation: {
		seed: irandom_range(9999, 99999999),
	},
	
	scale: irandom(6) + 2,
}

components.color = {
	red:   random(0.8) + other.components.resources.gold * 0.5,
	green: random(0.8) + other.components.resources.copper * 0.6,
	blue:  random(1.0) + other.components.resources.water * 0.9,
};


