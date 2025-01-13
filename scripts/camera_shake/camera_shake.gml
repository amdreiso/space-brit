function camera_shake(val, pwr = 1){
	if (!instance_exists(Camera)) return;
	with (Camera) {
		self.shakeValue = val;
		self.shakePower = pwr;
	}
}