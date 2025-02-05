function get_keymap(){
	return {
		forward: (keyboard_check(ord("W")) || gamepad_button_check(Gamepad, gp_shoulderrb)),
		left: (keyboard_check(ord("A")) || gamepad_axis_value(Gamepad, gp_axislh) < 0),
		right: (keyboard_check(ord("D")) || gamepad_axis_value(Gamepad, gp_axislh) > 0),
		
		attack: (keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(Gamepad, gp_shoulderr)),
		menu: (keyboard_check_pressed(ord("E")) || gamepad_button_check_pressed(Gamepad, gp_face4)),
		
		start: (keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(Gamepad, gp_start)),
		select: (mouse_check_button_pressed(mb_left) || gamepad_button_check_pressed(Gamepad, gp_face1)),
		selectHeld: (mouse_check_button(mb_left) || gamepad_button_check(Gamepad, gp_face1)),
		
		debug: (keyboard_check_pressed(vk_f3) || gamepad_button_check_pressed(Gamepad, gp_select)),
		
		leftAim: (gamepad_axis_value(Gamepad, gp_axisrh) < 0),
		rightAim: (gamepad_axis_value(Gamepad, gp_axisrh) > 0),
		
		padu: (gamepad_button_check(Gamepad, gp_padu)),
		padl: (gamepad_button_check(Gamepad, gp_padl)),
		padd: (gamepad_button_check(Gamepad, gp_padd)),
		padr: (gamepad_button_check(Gamepad, gp_padr)),
		
		paduPressed: (gamepad_button_check_pressed(Gamepad, gp_padu)),
		padlPressed: (gamepad_button_check_pressed(Gamepad, gp_padl)),
		paddPressed: (gamepad_button_check_pressed(Gamepad, gp_padd)),
		padrPressed: (gamepad_button_check_pressed(Gamepad, gp_padr)),
		
		player: {
			up: (keyboard_check(ord("W")) || gamepad_axis_value(Gamepad, gp_axislv) < 0),
			left: (keyboard_check(ord("A")) || gamepad_axis_value(Gamepad, gp_axislh) < 0),
			down: (keyboard_check(ord("S")) || gamepad_axis_value(Gamepad, gp_axislv) > 0),
			right: (keyboard_check(ord("D")) || gamepad_axis_value(Gamepad, gp_axislh) > 0),
			
			jump: (keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(Gamepad, gp_face1)),
		}
	}
}