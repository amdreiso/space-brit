function gp_anykey(){
	
  var dz = abs(0.25);
	var con = (
			
		gamepad_button_check(Gamepad,gp_extra1) ||
		gamepad_button_check(Gamepad,gp_extra2) ||
		gamepad_button_check(Gamepad,gp_extra3) ||
		gamepad_button_check(Gamepad,gp_extra4) ||
		gamepad_button_check(Gamepad,gp_extra5) ||
		gamepad_button_check(Gamepad,gp_face1) ||
		gamepad_button_check(Gamepad,gp_face2) ||
		gamepad_button_check(Gamepad,gp_face3) ||
		gamepad_button_check(Gamepad,gp_face4) ||
		gamepad_button_check(Gamepad,gp_home) ||
		gamepad_button_check(Gamepad,gp_start) ||
		gamepad_button_check(Gamepad,gp_select) ||
		gamepad_button_check(Gamepad,gp_shoulderr) ||
		gamepad_button_check(Gamepad,gp_shoulderl) ||
		gamepad_button_check(Gamepad,gp_shoulderrb) ||
		gamepad_button_check(Gamepad,gp_shoulderlb) ||
		gamepad_button_check(Gamepad,gp_padd) ||
		gamepad_button_check(Gamepad,gp_padu) ||
		gamepad_button_check(Gamepad,gp_padr) ||
		gamepad_button_check(Gamepad,gp_padl) ||
		gamepad_button_check(Gamepad,gp_paddlel) ||
		gamepad_button_check(Gamepad,gp_paddler) ||
		gamepad_button_check(Gamepad,gp_paddlelb) ||
		gamepad_button_check(Gamepad,gp_paddlerb) ||
		gamepad_button_check(Gamepad,gp_stickl) ||
		gamepad_button_check(Gamepad,gp_stickr) ||
		gamepad_button_check(Gamepad,gp_touchpadbutton) ||
			
		abs(gamepad_axis_value(Gamepad, gp_axislh)) > dz ||
		abs(gamepad_axis_value(Gamepad, gp_axislv)) > dz ||
		abs(gamepad_axis_value(Gamepad, gp_axisrh)) > dz ||
		abs(gamepad_axis_value(Gamepad, gp_axisrv)) > dz
			
	);
		
	return con;
}