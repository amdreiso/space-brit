
if (target == noone) return;


if (shakeValue > 0) shakeValue = lerp(shakeValue, 0, 0.1);

var shake = power(shakeValue, shakePower);

var xx = target.x + offset.x;
var yy = target.y + offset.y;

x = lerp(x, xx, followSpeed) + random_range(-shake, shake);
y = lerp(y, yy, followSpeed) + random_range(-shake, shake);


camera_set_view_angle(cam, angle);
camera_set_view_size(cam, defaultSize.width * zoomLerp, defaultSize.height * zoomLerp);

camera_set_view_pos(cam, x - (size.width * zoomLerp) / 2, y - (size.height * zoomLerp) / 2);

var zoomValue = 0.1;

if (keyboard_check(vk_shift)) {
	zoomValue = 2.5;
}

var map = get_keymap();

zoom += (mouse_wheel_down())									? zoomValue : 0;
zoom -= (mouse_wheel_up() && zoom > 0)				? zoomValue : 0;

zoomLerp = lerp(zoomLerp, zoom, 0.1);
