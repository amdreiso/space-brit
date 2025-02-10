


draw_3d(components.scale * 5, x, y, sprite_index, components.scale, components.scale, image_angle, 
	make_color_rgb(components.color.red * 255, components.color.green * 255, components.color.blue * 255), 1, false, 100, 5);


var shadowAngle = point_direction(x, y, sun.x, sun.y);
draw_sprite_ext(sPlanetShadow, 0, x, y, components.scale, components.scale, shadowAngle, c_white, 1);


image_angle += 0.001;

