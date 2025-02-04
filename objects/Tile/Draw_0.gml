
if (!active) return;

sprite_index = get_tile(tileID).sprite;

shader_set(shd_recolor);
shader_set_uniform_f(
	shader_get_uniform(shd_recolor, "u_color"), 
	color.red, 
	color.green, 
	color.blue
);

draw_self();

shader_reset();

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, shadow);

