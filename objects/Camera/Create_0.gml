
target = noone;


cam = view_camera[0];

defaultSize = new dim(
	camera_get_view_width(cam),
	camera_get_view_height(cam)
);

size = defaultSize;

angle = 0;
followSpeed = 0.1;

zoom = 1;
zoomLerp = zoom;

shakeValue = 0;
shakePower = 1;
