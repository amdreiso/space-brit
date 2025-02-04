
Keymap = get_keymap();

if (Keymap.debug) Debug = !Debug;
if (Keymap.start) {
	set_pause(!Paused);
}

if (keyboard_check_pressed(vk_rcontrol)) {
	Console = !Console;
	keyboard_string = "";
}

// Some values ig
ParticleCount = instance_number(Particle);


// Controller
if (mouse_check_button_pressed(mb_any) || keyboard_check_pressed(vk_anykey) && Controller != CONTROLLER.Keyboard) {
	Controller = CONTROLLER.Keyboard;
}

if (gp_anykey() && Controller != CONTROLLER.Gamepad) {
	Controller = CONTROLLER.Gamepad;
}

// Set gamepad deadzone
if (gamepad_is_connected(Gamepad) && gamepad_get_axis_deadzone(Gamepad) != Settings.gamepad.deadzone)
	gamepad_set_axis_deadzone(Gamepad, Settings.gamepad.deadzone);


// Some help
debug_controls();

