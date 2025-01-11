function fovy(){}

function vec2(x=0, y=0) constructor {self.x=x; self.y=y}

function dim(width=0, height=0) constructor {self.width=width; self.height=height}

function button(
	x, y, width, height, 
	hasOutline = true, outlineColor = c_white, hoverColor = c_white, hoverAlpha = 0.25, hoverFunction = function(){},
	orientation = 0
) {
	var range;
	
	switch (orientation) {
		case 0:				// top left
			
			range = (mouse_x > x && mouse_x < x + width && mouse_y > y && mouse_y < y + height);
			
			// Draw outline
			if (hasOutline) {
				draw_rectangle_color(
					x, y, 
					x + width, y + height, 
					outlineColor, outlineColor, outlineColor, outlineColor, true
				);
			}
			
			if (range) {
				draw_set_alpha(hoverAlpha);
				draw_rectangle_color(
					x, y, 
					x + width, y + height, 
					hoverColor, hoverColor, hoverColor, hoverColor, false
				);
				draw_set_alpha(1);
				
				hoverFunction();
			}
			
			break;
		
		case 1:				// middle center
			
			range = (
				mouse_x > x - width / 2 && 
				mouse_x < x + width / 2 && 
				mouse_y > y - height / 2 && 
				mouse_y < y + height / 2
			);
			
			// Draw outline
			if (hasOutline) {
				draw_rectangle_color(
					x - width / 2, y - height / 2, 
					x + width / 2, y + height / 2, 
					outlineColor, outlineColor, outlineColor, outlineColor, true
				);
			}
			
			if (range) {
				draw_set_alpha(hoverAlpha);
				draw_rectangle_color(
					x - width / 2, y - height / 2, 
					x + width / 2, y + height / 2, 
					hoverColor, hoverColor, hoverColor, hoverColor, false
				);
				draw_set_alpha(1);
				
				hoverFunction();
			}
			
			break;
	}
}

function draw_3d(step, sprite, xscale, yscale, angle = 0, color = c_white, alpha = 1) {
	for (var i = 0; i < sprite_get_number(sprite); i++) {
		var yy = y - (i * step);
		draw_sprite_ext(sprite, i, x, yy, xscale, yscale, angle, color, alpha);
	}
}

function save_id(file, save, prettify = false) {
	var str = json_stringify(save, prettify);
	var buffer = buffer_create(string_byte_length(str)+1, buffer_fixed, 1);
	
	buffer_write(buffer, buffer_text, str);
	buffer_save(buffer, file);
	buffer_delete(buffer);
}

function color_lerp(col1, col2, t) {
    var r1 = color_get_red(col1);
    var g1 = color_get_green(col1);
    var b1 = color_get_blue(col1);

    var r2 = color_get_red(col2);
    var g2 = color_get_green(col2);
    var b2 = color_get_blue(col2);

    var r = lerp(r1, r2, t);
    var g = lerp(g1, g2, t);
    var b = lerp(b1, b2, t);

    return make_color_rgb(r, g, b);
}


// Code from Arend Peter Teaches
function get_perlin_noise_1D(xx, range){
	var noise = 0;
	var chunkSize = 8;
	var chunkIndex = xx div chunkSize;
	var prog = (xx % chunkSize) / chunkSize;

	var leftRandom = random_seed(chunkIndex, range);
	var rightRandom = random_seed(chunkIndex + 1, range);

	noise = (1-prog)*leftRandom + prog*rightRandom;

	return round(noise);
}


// Code from Arend Peter Teaches
function get_perlin_noise_2D(xx, yy, range){
var chunkSize = 8;

	var noise = 0;

	range = range div 2;

	while(chunkSize > 0){
	    var index_x = xx div chunkSize;
	    var index_y = yy div chunkSize;
    
	    var t_x = (xx % chunkSize) / chunkSize;
	    var t_y = (yy % chunkSize) / chunkSize;
    
	    var r_00 = random_seed(range,index_x,   index_y);
	    var r_01 = random_seed(range,index_x,   index_y+1);
	    var r_10 = random_seed(range,index_x+1, index_y);
	    var r_11 = random_seed(range,index_x+1, index_y+1);
    
			var r_0 = lerp(r_00,r_01,t_y);
	    var r_1 = lerp(r_10,r_11,t_y);
   
	    noise += lerp(r_0,r_1,t_x);
    
	    chunkSize = chunkSize div 2;
	    range = range div 2;
	    range = max(1,range);
	}

	return round(noise);
}

function random_seed(range){
	var num = 0;
	
	switch(argument_count) {
		case 2:
			num = argument[1];
			break;
		case 3:
			num = argument[1] + argument[2] * 323232;
			break;
	}
	
	var seed = 0;
	seed += Seed + num;

	random_set_seed(seed);
	rand = irandom_range(0, range);

	return round(rand);
}
