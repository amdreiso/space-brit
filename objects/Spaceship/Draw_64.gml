
draw_stats();




if (place_meeting(x, y, Planet)) {
	
	tipAlpha = lerp(tipAlpha, 1, 0.1);
	
	draw_tip("press space to land", c_white, tipAlpha);
	
} else {
	
	tipAlpha = lerp(tipAlpha, 0, 0.1);
	
}
