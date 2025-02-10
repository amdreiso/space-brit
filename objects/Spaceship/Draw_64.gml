

if (room != rmOuterSpace) return;


// Tips
draw_tip("press F to land", c_white, c_red, tipAlpha);

if (distance_to_object(Planet) < 200) {
	tipAlpha = lerp(tipAlpha, 1, 0.05);
} else {
	tipAlpha = lerp(tipAlpha, 0, 0.1);
}


// Menu
drawMenu();


// Draw doodles
drawDoodles();


// Sun
calculateSunProximity();


// Hit red tint
hitAlpha = lerp(hitAlpha, 0, 0.1);

draw_set_alpha(hitAlpha);
draw_rectangle_color(
	0, 0, window_get_width(), window_get_height(),
	c_red, c_red, c_red, c_red, false
);
draw_set_alpha(1);


// Dead menu
drawDeadMenu();
