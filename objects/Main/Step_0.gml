
if (keyboard_check_pressed(vk_f3)) Debug = !Debug;
if (keyboard_check_pressed(vk_escape)) {
	set_pause(!Paused);
}

ParticleCount = instance_number(Particle);


debug_controls();

