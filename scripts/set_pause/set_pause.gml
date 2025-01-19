function set_pause(val){
	// Audio
	if (Paused) {
		audio_resume_all();
	} else {
		audio_pause_all();
	}
	
	Paused = val;
}