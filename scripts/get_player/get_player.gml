function get_player(){
	switch (room) {
		case rmOuterSpace:
			if (instance_exists(Spaceship)) return Spaceship;
			break;
			
		case rmPlanet:
			if (instance_exists(Player)) return Player;
			break;
	}
}