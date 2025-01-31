

if (distance_to_object(Spaceship) < 200) {
	if (keyboard_check_pressed(ord("F"))) {
		set_planet(components);
		
		audio_stop_all();
	}
}

orbit();
