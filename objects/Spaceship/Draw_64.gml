

// Menu
drawMenu();


// Tips
draw_tip("press F to land", c_white, c_red, tipAlpha);

if (distance_to_object(Planet) < 200) {
	
	tipAlpha = lerp(tipAlpha, 1, 0.05);
	
} else {
	
	tipAlpha = lerp(tipAlpha, 0, 0.1);
	
}



// Color tint
var sunAlpha = 1;

var sun = instance_nearest(x, y, Sun);

if (instance_exists(sun)) {
	var distance = distance_to_object(sun);
	var divider = 5000;
	var maxDistance = sprite_get_width(sun.sprite) * sun.scale;
	
	if (distance > maxDistance) {
		divider = 200;
	}
	
	sunAlpha = 1 / ((distance + 1) / divider);
}

draw_set_alpha(sunAlpha);

draw_rectangle_color(
	0, 
	0, 
	window_get_width(),
	window_get_height(),
	c_yellow,
	c_yellow,
	c_yellow,
	c_yellow,
	false
);

draw_set_alpha(1);
