

shader_set(shd_recolor);

shader_set_uniform_f(shader_get_uniform(shd_recolor, "u_color"), color.red, color.green, color.blue);

draw_3d(scale * 5, x, y, sprite_index, scale, scale, image_angle, c_white, 1, true, 100, 5);

shader_reset();


var shadowAngle = point_direction(x, y, sun.x, sun.y);
draw_sprite_ext(sPlanetShadow, 0, x, y, scale, scale, shadowAngle, c_white, 1);


image_angle += 0.001;

