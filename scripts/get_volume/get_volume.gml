function get_volume(audio){
	var val = 1;
	
	switch (audio) {
		case AUDIO.Master:
			val = Settings.volume.master;
			break;
			
		case AUDIO.Effects:
			val = Settings.volume.effects * Settings.volume.master;
			break;
			
		case AUDIO.Music:
			val = Settings.volume.music * Settings.volume.master;
			break;
	}
	
	return val;
}