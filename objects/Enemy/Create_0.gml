
busy = false;
sleep = 0;

// Movement
acceleration = 0.09;
spd = 0;
maxSpeed = 2.0;
hsp = 0;
vsp = 0;
angle = 0;

force = new vec2();

directionOffsetMaxValue = 50.00;
directionOffsetValue = 0;
directionOffset = -random_range(-directionOffsetMaxValue, directionOffsetMaxValue);

alarm[0] = random_range(1.00, 6.00) * 60;

moveForward = true;
isMoving = false;
target = Spaceship;

seed = irandom_range(100000, 1000000000);


// Sound
emitter = audio_emitter_create();
propellantSound = -1;


handleMovement = function() {
	
	if (busy) return;
	
	isMoving = (hsp != 0 || vsp != 0);
	
	force.x = lerp(force.x, 0, 0.01);
	force.y = lerp(force.y, 0, 0.01);
	
	directionOffsetValue = lerp(directionOffsetValue, directionOffset, 0.1);
	
	// Follow target
	if (target != noone) {
		direction = point_direction(x, y, target.x, target.y) + directionOffsetValue;
		
		hsp = lengthdir_x(spd, direction);
		vsp = lengthdir_y(spd, direction);
		
		if (spd < maxSpeed) spd += acceleration;
		
		x += hsp + force.x;
		y += vsp + force.y;
	}
	
	if (moveForward) {
		var offset = 10;
		var range = 4;
		
		var xx = x - lengthdir_x(offset, direction) + irandom_range(-range, range);
		var yy = y - lengthdir_y(offset, direction) + irandom_range(-range, range);
		
		repeat (1) {
			with (instance_create_layer(round(xx), round(yy), "Glowing_Particles", Particle)) {
				self.sprite_index = sPixel_particle;
				self.image_speed = 0;
				self.image_index = irandom(sprite_get_number(self.sprite_index)-1);
				
				var ton = irandom_range(0, 5);
				var black = make_color_rgb(ton, ton, ton);
				
				self.spd = irandom(3) + 1;
				self.move = function(value) {
					x += irandom_range(-value, value);
					y += irandom_range(-value, value);
				
					self.spd += 1;
				};
				
				self.step = irandom_range(10, 20);
				
				var colorArray = [c_green, c_lime];
				var colorIndex = irandom(array_length(colorArray)-1);
				
				self.color = [colorArray[colorIndex], black, random_range(0.01, 0.05)];
				self.destroyTime = (irandom(2) + 1) * 30;
				self.scale = 1;
				
				self.fadeOut = true;
				self.fadeTime = 0.05;
			}
		}
		
		// SFX
		if (!audio_is_playing(propellantSound)) {
			propellantSound = sound3D(emitter, xx, yy, snd_propellant_enemy, false, 0, 1);
		}
		
		audio_sound_gain(propellantSound, 0.03 * get_volume(AUDIO.Effects), 300);
		audio_emitter_position(emitter, xx, yy, 0);
		
	} else {
		spd = lerp(spd, 0, 0.05);
		
		if (propellantSound != -1) {
			audio_sound_gain(propellantSound, 0, 300);
		}
	}
	
	// EXPEL THE ENEMIES!
	var minimumDistance = 6;
	
	for (var i = 0; i < instance_number(Enemy); i++) {
    var enemy = instance_find(Enemy, i);
    
		if (enemy != id) {
      var dist = point_distance(x, y, enemy.x, enemy.y);
        
			if (dist < minimumDistance) {
        var angle = point_direction(x, y, enemy.x, enemy.y);
        var push_distance = (minimumDistance - dist) / 20;
						
        force.x += lengthdir_x(push_distance, angle);
        force.y += lengthdir_y(push_distance, angle);
      }
    }
	}
}


// Health
isHit = false;
hp = 100;
dead = false;

hitCooldown = 0;

hit = function(damage) {
	isHit = true;
	hp -= damage;
	
	hitCooldown = 10;
	sleep = 15;  
	
	dead = (hp <= 0);
	
	sound3D(emitter, x, y, snd_hit1, false, 0.24 * get_volume(AUDIO.Effects), random_range(0.85, 1.00));
	camera_shake(2);
}


// Draw
sprite = sAlien1;

drawEnemy = function() {
	if (sprite == -1) return;
	
	sprite_index = sprite;
	
	gpu_set_fog((hitCooldown > 0), c_red, 0, 1);
	
	draw_3d(1, x, y, sprite, 1, 1, direction - 90, c_white, 1);
	
	gpu_set_fog(false, c_white, 0, 1);
}



