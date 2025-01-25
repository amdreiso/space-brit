

shader_set(shd_sun);

shader_set_uniform_f(shader_get_uniform(shd_sun, "u_Distance"), 1.0);
shader_set_uniform_f(shader_get_uniform(shd_sun, "u_Intensity"), 1.25);

draw_sprite_ext(sprite, 0, x, y, scale, scale, 0, c_white, 1);
draw_sprite_ext(sprite, 0, x, y, scale, scale, image_angle, c_white, 1);

shader_reset();

image_angle += 0.001;


