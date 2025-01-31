function debug_controls(){
	if (!Debug) return;
	
	var player = get_player();
	
	if (keyboard_check(vk_control)) {
		
		if (mouse_check_button(mb_left)) {
			if (instance_exists(player))
				player.x = mouse_x
				player.y = mouse_y
		}
		
	}
}