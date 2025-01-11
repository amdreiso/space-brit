

var minSpeedTurn = speed / 3;
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
	
	repeat (40) {
		var offset = 18;
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
			
			self.color = [choose(c_orange, c_orange, c_red), black, 0.08];
			self.destroyTime = (irandom(2) + 1) * 30;
			self.scale = 1;
		}
	}
	
} else {
	speed = lerp(speed, 0, 0.05);
	turn = lerp(turn, 0, 0.1);
}

angle += turn;

direction = angle;



create_stars();

