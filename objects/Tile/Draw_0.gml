
if (!active) return;

sprite_index = get_tile(tileID).sprite;

image_blend = make_color_rgb(
	color.red * 255, 
	color.green * 255, 
	color.blue * 205
); 

draw_self();

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, shadow);

