function camera_set_target(target){
	if (!instance_exists(Camera) || Camera.target == target) return;
	Camera.target = target;
}