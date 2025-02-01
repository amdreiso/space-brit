function camera_set_target(target, brute=false){
	if (!instance_exists(Camera) || Camera.target == target) return;
	Camera.target = target;
	
	if (brute) {
		Camera.x = target.x;
		Camera.y = target.y;
	}
}