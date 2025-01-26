

shader_set(shd_recolor);

shader_set_uniform_f(shader_get_uniform(shd_recolor, "u_color"), color.red, color.green, color.blue);

draw_3d(scale * 5, x, y, sprite_index, scale, scale, image_angle, c_white, 1, true, 100, 5);

shader_reset();

image_angle += 0.001;

