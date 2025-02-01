

sun = instance_create_layer(x, y, "Glowing_Particles", Sun);

planets = [];
planetAmount = irandom_range(2, 10);

planetDistance = 0;

for (var i = 0; i < planetAmount; i++) {
	var planet;
	planet = instance_create_layer(x, y, "Planets", Planet);
	
	planetDistance += irandom_range(7000, 30000) + 1000;
	
	with (planet) {
		self.distanceToSun = other.planetDistance;
		self.sun = other.sun;
	}
	
	array_push(planets, planet);
}

