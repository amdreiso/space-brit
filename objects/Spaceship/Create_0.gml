

turn = 0;
angle = 0;

maxSpeed = 2.5;
acceleration = 0.05;

turnPrecision = 0.25;
turnSpeed = 0.2;


fuel = 1;


with (instance_create_depth(x, y, depth, Camera)) {
	self.target = other;
}

