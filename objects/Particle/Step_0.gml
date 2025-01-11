
tick += GameSpeed;

if (tick % step == true) {
	move(spd);
}

if (tick > destroyTime) {
	instance_destroy();
}


