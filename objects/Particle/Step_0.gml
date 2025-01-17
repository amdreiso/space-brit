
tick += GameSpeed;

if (step != 0 && tick % step == true) {
	move(spd);
}

if (tick > destroyTime && destroyTime != 0) {
	instance_destroy();
}

var dx = lengthdir_x(Spaceship.speed * depthFactor, Spaceship.direction);
var dy = lengthdir_y(Spaceship.speed * depthFactor, Spaceship.direction);
x -= dx;
y -= dy;

update();
