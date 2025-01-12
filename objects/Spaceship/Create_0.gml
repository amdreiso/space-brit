
// Movement
turn = 0;
turnForce = 10;
angle = irandom(360);

maxSpeed = 2.5;
acceleration = 0.05;

turnPrecision = 0.25;
turnSpeed = 0.2;


fuel = 1;


// Camera
with (instance_create_depth(x, y, depth, Camera)) {
	self.target = other;
}


// States
inBattle = false;


// Sound
propellant = -1;


// Tips
tipAlpha = 0;


