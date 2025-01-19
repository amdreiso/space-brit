
busy = (Paused);

if (busy) return;

tick += GameSpeed;

if (step != 0 && tick % step == true) {
	move(spd);
}

if (tick > destroyTime && destroyTime != 0) {
	if (fadeOut > 0) {
		alpha = lerp(alpha, 0, fadeTime);
		
		if (alpha < 0.05) instance_destroy();
	}
} else {
	if (fadeIn > 0) {
		alpha = lerp(alpha, 1, fadeTime);
	}
}

var dx = lengthdir_x(Spaceship.speed * depthFactor, Spaceship.direction);
var dy = lengthdir_y(Spaceship.speed * depthFactor, Spaceship.direction);
x -= dx;
y -= dy;





update();
