function set_planet(components, playerPos = vec2(0, 0)){
	
	// Change rooms
	room_goto(rmPlanet);
	
	
	// Planet Components
	PlanetHandler.components = components;
	
	
	// Set player position
	get_player().x = playerPos.x;
	get_player().y = playerPos.y;
	
	audio_stop_all();
	
	
	show_debug_message(json_stringify(PlanetHandler.components, true));
}