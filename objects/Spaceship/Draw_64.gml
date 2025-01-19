


// Menu
if (keyboard_check_pressed(ord("E")) && !Paused) {
	menu = !menu;
}

drawMenu();



// Tips
draw_tip("press F to land", c_white, c_red, tipAlpha);

if (distance_to_object(Planet) < 200) {
	
	tipAlpha = lerp(tipAlpha, 1, 0.05);
	
} else {
	
	tipAlpha = lerp(tipAlpha, 0, 0.1);
	
}

