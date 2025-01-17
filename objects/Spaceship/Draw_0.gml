

var starKeys = ds_map_keys_to_array(StarGrid);

for (var i = 0; i < array_length(starKeys); i++) {
	var key = starKeys[i];
	var val = ds_map_find_value(StarGrid, key);
	
	var c = Stars.chunk;
	
	if (Debug) {
		draw_set_alpha(0.2);
		rect(val.x, val.y, c, c, c_red, true);
		draw_set_alpha(1);
	}
}


var s = 1;
var turretSprite;

if (shootingCooldown > 0) {
	turretSprite = sTurretCooldown;
} else {
	turretSprite = sTurret;
}



draw_3d(s, x, y+3, turretSprite, s, s, mouseAngle - 90, c_white, 1, true, 100, 10);
draw_3d(s, x, y, sSpaceship, s, s, direction-90);


sprite_index = sSpaceship;


// Window
button(x, y, 8, 8, "", false, 0, 0, 0, function(){
	if (!Paused) return;
	
	if (mouse_check_button_pressed(mb_left) && winStatus == -1) {
		with (instance_create_depth(x, y, -1000, Window)) {
			
		}
	}
	
	window_set_cursor(cr_handpoint);
	
	draw_text_transformed_color(mouse_x+7.5, mouse_y+.5, "Spaceship", .5, .5, 0, c_black, c_black, c_black, c_black, 1);
	draw_text_transformed(mouse_x+8, mouse_y, "Spaceship", .5, .5, 0);
	
}, BUTTON_ORIGIN.MiddleCenter);


