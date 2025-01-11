
if (target == noone) return;

x = lerp(x, target.x, followSpeed);
y = lerp(y, target.y, followSpeed);

camera_set_view_angle(cam, angle);
camera_set_view_size(cam, defaultSize.width * zoomLerp, defaultSize.height * zoomLerp);

camera_set_view_pos(cam, x - (size.width * zoomLerp) / 2, y - (size.height * zoomLerp) / 2);

var zoomValue = 0.1;

if (keyboard_check(vk_shift)) {
	zoomValue = 0.5;
}

zoom += (mouse_wheel_down() && zoom < 10)			? zoomValue : 0;
zoom -= (mouse_wheel_up() && zoom > 0)				? zoomValue : 0;

zoomLerp = lerp(zoomLerp, zoom, 0.1);
