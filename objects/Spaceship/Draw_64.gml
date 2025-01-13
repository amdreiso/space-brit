
// Debug
draw_stats();

draw_tip("press F to land", c_white, c_red, tipAlpha);

if (distance_to_object(Planet) < 200) {
	
	tipAlpha = lerp(tipAlpha, 1, 0.05);
	
	if (keyboard_check_pressed(ord("F"))) {
		room_goto(rmPlanet);
		
		audio_stop_all();
	}
	
} else {
	
	tipAlpha = lerp(tipAlpha, 0, 0.1);
	
}
