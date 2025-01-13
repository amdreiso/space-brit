
// Movement
defaultSpd = 0.67;
spd = defaultSpd;
hsp = 0;
vsp = 0;
force = new vec2();

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

drawPlayer = function() {
	if (hsp != 0) image_xscale = sign(hsp);
	
	if (isMoving) {
		sprite_index = spriteState.move;
	} else {
		sprite_index = spriteState.idle;
	}
	
	draw_self();
}


// Camera
with (instance_create_depth(x, y, depth, Camera)) {
	self.target = other;
}

