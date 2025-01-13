
tick += GameSpeed;

switch ( room ) {
	
	case rmOuterSpace:
		
		var ambienceArr = [
			snd_ambience1,
			snd_ambience2,
			snd_ambience3,
			snd_ambience4,
			snd_ambience5,
			snd_ambience6,
		];
		
		if (tick > randomAmbienceTime) {
			randomAmbienceTime = random_range(20, 220) * 60;
			
			var song = ambienceArr[irandom(array_length(ambienceArr)-1)];
			
			audio_play_sound(
				song, 0, false, 
				random_range(0.25, 0.55) * Volume.music, 0
			);
			
			show_debug_message("Ambience Song");
			
			tick = 0;
		}
		
		break;
	
}

