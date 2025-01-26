


// Tips
draw_tip("press F to land", c_white, c_red, tipAlpha);

if (distance_to_object(Planet) < 200) {
	tipAlpha = lerp(tipAlpha, 1, 0.05);
} else {
	tipAlpha = lerp(tipAlpha, 0, 0.1);
}



// Menu
drawMenu();



// Draw doodles
drawDoodles();



// Color tint
var sun = instance_nearest(x, y, Sun);

// If spaceship is in suns radius
inSunRadius = (distanceToSun < distanceToSunOffset);

if (instance_exists(sun)) {
	var disOffset = (sprite_get_width(sun.sprite) * sun.scale) / 2;
  var dir = point_direction(sun.x, sun.y, x, y);
    
  var xx = lengthdir_x(disOffset, dir);
  var yy = lengthdir_y(disOffset, dir);
    
  var edgeX = sun.x + xx;
  var edgeY = sun.y + yy;

  distanceToSun = point_distance(x, y, edgeX, edgeY);
	var divider = 1000;
	var maxDistance = sprite_get_width(sun.sprite) * sun.scale;
	
	// beep sfx
	distanceToSunOffset = disOffset * 2;
	
	if (!inSunRadius) return;
	
	if (!menuSettings.sunProximityAlert) return;
	
	var beepDis = distanceToSun / distanceToSunOffset;
	var beepGain = abs(0.25 / (beepDis * 2));
	beepGain = clamp(beepGain, 0, 0.60);
	
	var minFreq = 100;
	var maxFreq = 1000;
	
	var freq = clamp(minFreq + (maxFreq - minFreq) * (distanceToSun / maxDistance), minFreq, maxFreq);
	
	beepInterval += GameSpeed;
	
	if (beepInterval > freq / (15)) {
		beepInterval = 0;
		audio_play_sound(snd_alert1, 0, false, beepGain * get_volume(AUDIO.Effects));
	}
}









