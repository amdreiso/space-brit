function gp_anykey(){
	for (var i = 0; i <= 19; i++) {
    var dz = abs(0.25);
		var con = (
			gamepad_button_check(Gamepad, i) ||
			gamepad_axis_value(Gamepad, gp_axislh) > dz ||
			gamepad_axis_value(Gamepad, gp_axislv) > dz ||
			gamepad_axis_value(Gamepad, gp_axisrh) > dz ||
			gamepad_axis_value(Gamepad, gp_axisrv) > dz
		);
		
		if (con) {
      show_debug_message("Pressing something");
			
			return true;
    }
	}
	
	return false;
}