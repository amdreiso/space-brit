
sprite_index = sPlanet1;

scale = get_perlin_noise_2D(x, y, 6) + 2;


// Center of solar system
sun = -1;
distanceToSun = 0;

orbitSpeed = 199.0002;

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
		angle = get_perlin_noise_2D(x, y, 360, false);
		setAngle = true;
	}
}

show_debug_message(angle);


// Planet variables
components = {
	resources: {
		water:						random(1) / irandom(20),
		stone:						random(1),
		iron:							random(1),
		copper:						random(1),
		gold:							random(1),
		silver:						random(1),
	}
}


