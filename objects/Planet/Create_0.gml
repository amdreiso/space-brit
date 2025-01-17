
sprite_index = sPlanet1;

scale = get_perlin_noise_2D(x, y, 6) + 2;


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


