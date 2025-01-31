
// Movement
defaultSpd = 0.67;
spd = defaultSpd;
hsp = 0;
vsp = 0;
force = new vec2();


isJumping = false;
jumpTick = 0;
jumpTime = 1 * 60;

var Components = function() constructor {
	self.stamina = 100;
}

components = new Components();


// Draw
isMoving = false;
spriteState = {
	idle: sPlayerIdle,
	move: sPlayerMove,
}

spriteDirection = new vec2(1, 1);

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



