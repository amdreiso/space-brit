

enum BUTTON_ORIGIN {
	Left, 
	MiddleCenter,
}


function fovy(){
	show_debug_message("Loaded FOVY!");
}

function vec2(x=0, y=0) constructor {self.x=x; self.y=y}

function dim(width=0, height=0) constructor {self.width=width; self.height=height}

function rgb(r, g, b) constructor { self.r = r; self.g = g; self.b = b; }

function button(
	x, y, width, height, 
	hasOutline = true, outlineColor = c_white, hoverColor = c_white, hoverAlpha = 0.25, hoverFunction = function(){},
	orientation = 0
) {
	var range;
	
	switch (orientation) {
		case BUTTON_ORIGIN.Left:
			
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
		
		case BUTTON_ORIGIN.MiddleCenter:
			
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

function draw_3d(step, x, y, sprite, xscale, yscale, angle = 0, color = c_white, alpha = 1, smoothing = false, smoothOffset = 100, smoothStep = 5) {
	for (var i = 0; i < sprite_get_number(sprite); i++) {
		var yy = y - (i * step);
		var c = color;
		
		if (smoothing) {
			c = make_color_rgb(
				smoothOffset + i * smoothStep,
				smoothOffset + i * smoothStep,
				smoothOffset + i * smoothStep
			);
		}
		
		draw_sprite_ext(sprite, i, x, yy, xscale, yscale, angle, c, alpha);
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
function get_perlin_noise_2D(xx, yy, range, r = false){
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
	
	if (r) {
		return round(noise);
	}
	
	return noise;
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
	rand = random_range(0, range);

	return rand;
}

function rect(x, y, width, height, color = c_white, outline = false) {
	draw_rectangle_color(
		x-width/2, y-height/2, x+width/2, y+height/2, 
		color, color, color, color, outline
	);
}

function random_array_argument(array){
	if (is_array(array)) {
		return random_range(array[0], array[1]);
	}
	
	return array;
}

function sound3D(emitter, x, y, snd, loop, gain, pitch, offset = 0){
	if (emitter == -1) {
		return audio_play_sound_at(snd, x, y, 0, Sound.distance, Sound.dropoff, Sound.multiplier, 
			loop, -1, random_array_argument(gain), offset, random_array_argument(pitch));
	}
	
	return audio_play_sound_on(emitter, snd, loop, 0, random_array_argument(gain), offset, random_array_argument(pitch));
}
