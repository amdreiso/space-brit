

if (distance_to_object(Spaceship) < 200) {
	if (keyboard_check_pressed(ord("F"))) {
		room_goto(rmPlanet);
		
		with (PlanetHandler) {
			self.seed = irandom_range(10000, 1000000000);
		}
		
		audio_stop_all();
	}
}

orbit();
