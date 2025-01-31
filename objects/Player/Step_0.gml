
if (room != rmPlanet) return;


isMoving = (hsp != 0 || vsp != 0);

var up = keyboard_check(ord("W"));
var left = keyboard_check(ord("A"));
var down = keyboard_check(ord("S"));
var right = keyboard_check(ord("D"));

var dir = point_direction(0, 0, right-left, down-up);
var len = (right-left != 0) || (down-up != 0);


hsp = lengthdir_x(spd * len, dir);
vsp = lengthdir_y(spd * len, dir);


x += hsp + force.x;
y += vsp + force.y;


//if (isMoving) {
//	force.x = hsp / 2;
//	force.y = vsp / 2;
//}

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

if (keyboard_check_pressed(vk_space) && !isJumping) {
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



// Camera
camera_set_target(Player);

