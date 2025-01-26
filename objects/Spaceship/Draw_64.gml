

// Menu
drawMenu();


// Tips
draw_tip("press F to land", c_white, c_red, tipAlpha);

if (distance_to_object(Planet) < 200) {
	tipAlpha = lerp(tipAlpha, 1, 0.05);
} else {
	tipAlpha = lerp(tipAlpha, 0, 0.1);
}



// Color tint
var sun = instance_nearest(x, y, Sun);

if (instance_exists(sun)) {
	var distance = distance_to_object(sun);
	var divider = 1000;
	var maxDistance = sprite_get_width(sun.sprite) * sun.scale;
	
	// beep sfx
	var offset = 20000;
	if (distance > offset) return;
	
	var beepDis = distance / offset;
	var beepGain = abs(0.25 / beepDis);
	
	var minFreq = 100;
	var maxFreq = 1000;
	
	var freq = clamp(minFreq + (maxFreq - minFreq) * (distance / maxDistance), minFreq, maxFreq);
	
	beepInterval += GameSpeed;
	
	if (beepInterval > freq / (15)) {
		beepInterval = 0;
		audio_play_sound(snd_alert1, 0, false, beepGain * get_volume(AUDIO.Effects));
	}
}





