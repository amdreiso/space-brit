

// Health
hp = 1000;


// Movement
force = new vec2();

turn = 0;
turnForce = 10;
angle = irandom(360);

maxSpeed = 2.5;
acceleration = 0.05;

turnPrecision = 0.25;
turnSpeed = 0.2;

mouseAngle = 0;

fuel = 1;


handleMovement = function() {
	x += force.x;
	y += force.y;

	force.x = lerp(force.x, 0, 0.02);
	force.y = lerp(force.y, 0, 0.02);


	mouseAngle = point_direction(x, y, mouse_x, mouse_y);

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


	// Move Forward
	if (keyboard_check(ord("W"))) {
	
		speed += acceleration;
		speed = clamp(speed, 0, maxSpeed);
		var offset = 10;
		var range = 3;
		
		var xx = (x) - lengthdir_x(offset, direction) + irandom_range(-range, range);
		var yy = (y) - lengthdir_y(offset, direction) + irandom_range(-range, range);
		
		repeat (opt(50, fps)) {
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
			propellantSound = sound3D(emitter, xx, yy, snd_propellant, false, 0, [0.98, 1.01]);
		}
	
		audio_sound_gain(propellantSound, 0.03 * Settings.volume.effects, 300);
		audio_emitter_position(emitter, xx, yy, 0);
	
	} else {
		speed = lerp(speed, 0, 0.05);
		turn = lerp(turn, 0, 0.1);
	
		if (propellantSound != -1) {
			audio_sound_gain(propellantSound, 0, 300);
		}
	}

	angle += turn;
	direction = angle;
}


// Attacking
handleAttack = function() {
	if (keyboard_check_pressed(vk_space) && shootingCooldown == 0) {
		var spaceBetween = 4;
	
		var offset_x = lengthdir_x(spaceBetween, direction + 90);
		var offset_y = lengthdir_y(spaceBetween, direction + 90);
	
	
		with (instance_create_depth(x + offset_x, y + offset_y, depth+10, SpaceshipProjectile)) {
			self.sprite_index = sProjectile1;
			self.direction = other.mouseAngle;
			self.speed = 9;
		}
	
		with (instance_create_depth(x - offset_x, y - offset_y, depth+10, SpaceshipProjectile)) {
			self.sprite_index = sProjectile1;
			self.direction = other.mouseAngle;
			self.speed = 9;
		}
	
		camera_shake(0.75);
		shootingCooldown = 10;
	
		audio_play_sound(snd_shoot, 0, false, 0.10, 0);
	
		// Recoil
		force.x -= lengthdir_x(0.3, mouseAngle);
		force.y -= lengthdir_y(0.3, mouseAngle);
	}

	if (shootingCooldown > 0) shootingCooldown -= GameSpeed;
}

shootingCooldown = 0;


// Camera
with (instance_create_depth(x, y, depth, Camera)) {
	self.target = other;
}


// States
inBattle = false;


// Sound
emitter = audio_emitter_create();
propellantSound = -1;


// Tips
tipAlpha = 0;


// Status Window
winStatus = -1;



