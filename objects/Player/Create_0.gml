
// Busy duh
busy = false;


// Movement
x = 0; y = 0;

defaultSpd = 0.67;
spd = defaultSpd;
hsp = 0;
vsp = 0;
force = vec2();

isJumping = false;
jumpTick = 0;
jumpTime = 1 * 60;

var Components = function() constructor {
	self.stamina = 100;
}

components = new Components();


handleMovement = function() {
	
	if (busy) return;
	
	isMoving = (hsp != 0 || vsp != 0);

	var up = Keymap.player.up;
	var left = Keymap.player.left;
	var down = Keymap.player.down;
	var right = Keymap.player.right;

	var dir = point_direction(0, 0, right-left, down-up);
	var len = (right-left != 0) || (down-up != 0);

	hsp = lengthdir_x(spd * len, dir);
	vsp = lengthdir_y(spd * len, dir);

	x += hsp + force.x;
	y += vsp + force.y;

	force.x = lerp(force.x, 0, 0.02);
	force.y = lerp(force.y, 0, 0.02);

	// Jump
	if (jumpTick > 0) jumpTick -= GameSpeed; else {
		if (isJumping) {
			scale = 1;
			image_angle = 0;
		}
		isJumping = false;
	}

	if (Keymap.player.jump && !isJumping) {
		isJumping = true;
		jumpTick = jumpTime;
	
		camera_shake(1.00);
	
		// Create particles
		repeat (irandom_range(3, 6) * 5) {
			var xx, yy;
			var range = 5;
			xx = x + random_range(-range, range);
			yy = y + random_range(-range, range);
		
			with (instance_create_depth(xx, yy, depth, Particle)) {
			
				self.sprite_index = sPixel_particle;
				self.image_speed = 0;
				self.image_index = irandom(sprite_get_number(self.sprite_index)-1);
			
				self.spd = 0.5;
				self.step = irandom_range(10, 20);
			
				self.move = function(value) {
					x += irandom_range(-value, value);
					y += irandom_range(-value, value);
			
					self.spd = irandom(3);
				};
			
				self.spd = irandom(3);
			
				self.color = c_white;
				self.destroyTime = (irandom(1) + 1) * 30;
				self.scale = 1;
				
				self.fadeOut = true;
				self.fadeTime = 0.05;
			
				self.alpha = 0.5;
			
			}
		}
	}
}



// Draw
isMoving = false;
spriteState = {
	idle: sPlayerIdle,
	move: sPlayerMove,
}

spriteDirection = vec2(1, 1);

scale = 1;

drawPlayer = function() {
	if (hsp != 0) spriteDirection.x = sign(hsp);
	
	image_speed = 1;
	
	if (isJumping) {
		
		sprite_index = spriteState.move;
		
		image_speed = 0;
		image_index = 0;
		
	} else if (isMoving) {
		
		sprite_index = spriteState.move;
		
	} else {
		
		sprite_index = spriteState.idle;
		
	}
	
	if (isJumping) {
		scale = lerp(scale, 1.25, 0.25);
		image_angle = sin(current_time * 0.008) * 8;
	}
	
	image_xscale = scale * spriteDirection.x;
	image_yscale = scale * spriteDirection.y;
	
	draw_self();
}



