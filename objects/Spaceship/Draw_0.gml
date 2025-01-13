

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

draw_3d(s, x, y+3, turretSprite, s, s, mouseAngle-90);

draw_3d(s, x, y, spr_spaceship, s, s, direction-90);


sprite_index = spr_spaceship;

