
busy = false;

if (ParticleCount >= Settings.maxParticlesOnScreen) {
	instance_destroy();
	return;
}

color = c_white;

spd = 1;

step = 10;
tick = 0;
destroyTime = 0;

move = function(val){}

depthFactor = 1;
scale = 1;

update = function(){}
draw = function(){}

fadeIn = 0;
fadeOut = 0;
fadeTime = 0.1;

alpha = 1;

if (fadeIn != 0) alpha = 0;
