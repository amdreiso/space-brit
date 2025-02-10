
busy = (Paused || sleep > 0);

handleMovement();


// Health
if (hitCooldown > 0) hitCooldown -= GameSpeed; else isHit = false;
if (sleep > 0) sleep -= GameSpeed;

if (place_meeting(x, y, SpaceshipProjectile) && !isHit) {
	hit(10);
	instance_destroy(instance_nearest(x, y, SpaceshipProjectile));
}

if (dead) {
	repeat (100) {
		var range = 20;
		var xx = x + random_range(-range, range);
		var yy = y + random_range(-range, range);
		
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
			
			var colorArray = [c_red, c_orange, c_yellow, c_yellow, c_yellow];
			var colorIndex = irandom(array_length(colorArray)-1);
			
			self.color = [colorArray[colorIndex], black, random_range(0.01, 0.002)];
			self.destroyTime = (irandom(2) + 1) * 30;
			self.scale = irandom(3)+1;
			
			self.fadeOut = true;
			self.fadeTime = 0.05;
		}
	}
	
	sound3D(emitter, x, y, snd_explosion1, false, 0.44 * get_volume(AUDIO.Effects), [0.70, 1.00]);
	
	if (irandom(100) > 90)
		sound3D(emitter, x, y, choose(snd_death1, snd_death2), false, 0.04 * get_volume(AUDIO.Effects), random_range(0.85, 1.00));
	
	audio_stop_sound(snd_propellant_enemy);
	instance_destroy();
}
