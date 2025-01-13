
// Health
hp = 1000;



// Movement
turn = 0;
turnForce = 10;
angle = irandom(360);

maxSpeed = 2.5;
acceleration = 0.05;

turnPrecision = 0.25;
turnSpeed = 0.2;

mouseAngle = 0;

fuel = 1;


// Shooting
shootingCooldown = 0;


// Camera
with (instance_create_depth(x, y, depth, Camera)) {
	self.target = other;
}


// States
inBattle = false;


// Sound
emitter = audio_emitter_create();
propellant = -1;


// Tips
tipAlpha = 0;


