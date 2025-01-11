
if (sprite_index == -1) return;

if (is_array(color)) {
	
	image_blend = color[0];
	color[0] = color_lerp(color[0], color[1], color[2]);
	
} else {
	image_blend = color;
}

image_xscale = scale;
image_yscale = scale;

draw_self();
