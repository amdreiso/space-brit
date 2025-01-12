

var minSpeedTurn = speed / turnForce;
var maxTurnSpeed = 5;

if (keyboard_check(ord("A"))) {
	
	turn -= turnSpeed * minSpeedTurn;
	
} else if (keyboard_check(ord("D"))) {
	
	turn += turnSpeed * minSpeedTurn;
	
} else {
	turn = lerp(turn, 0, 0.1);
}


turn = clamp(turn, -maxTurnSpeed, maxTurnSpeed);


if (keyboard_check(ord("W"))) {
	
	speed += acceleration;
	speed = clamp(speed, 0, maxSpeed);
	
	repeat (30) {
		var offset = 15;
		var range = 3;
		
		var xx = (x) - lengthdir_x(offset, direction) + irandom_range(-range, range);
		var yy = (y) - lengthdir_y(offset, direction) + irandom_range(-range, range);
		
		with (instance_create_layer(round(xx), round(yy), "Glowing_Particles", Particle)) {
			self.sprite_index = sPixel_particle;
			
			var ton = irandom_range(5, 10);
			var black = make_color_rgb(ton, ton, ton);
			
			self.spd = irandom(3) + 1;
			self.move = function(value){
				x += irandom_range(-value, value);
				y += irandom_range(-value, value);
				
				self.spd += 1;
			};
			
			self.step = irandom_range(10, 20);
			
			self.color = [choose(c_orange, c_orange, c_red), black, 0.08];
			self.destroyTime = (irandom(2) + 1) * 30;
			self.scale = 1;
		}
	}
	
	// SFX
	if (!audio_is_playing(snd_propellant)) {
		propellant = audio_play_sound(snd_propellant, 0, false, 0);
	}
	
	audio_sound_gain(propellant, 0.23 * Volume.effects, 300);
	audio_sound_pitch(propellant, random_range(0.97, 1.01));
	
} else {
	speed = lerp(speed, 0, 0.05);
	turn = lerp(turn, 0, 0.1);
	
	if (propellant != -1) {
		audio_sound_gain(propellant, 0, 300);
	}
}

angle += turn;
direction = angle;


