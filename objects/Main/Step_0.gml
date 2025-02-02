
Keymap = get_keymap();

if (Keymap.debug) Debug = !Debug;
if (Keymap.start) {
	set_pause(!Paused);
}

ParticleCount = instance_number(Particle);


// Controler
if (mouse_check_button_pressed(mb_any) || keyboard_check_pressed(vk_anykey) && Controller != CONTROLLER.Keyboard) {
	Controller = CONTROLLER.Keyboard;
}

if (gp_anykey() && Controller != CONTROLLER.Gamepad) {
	Controller = CONTROLLER.Gamepad;
}


debug_controls();



