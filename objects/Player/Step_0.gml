
isMoving = (hsp != 0 || vsp != 0);

var up = keyboard_check(ord("W"));
var left = keyboard_check(ord("A"));
var down = keyboard_check(ord("S"));
var right = keyboard_check(ord("D"));

var dir = point_direction(0, 0, right-left, down-up);
var len = (right-left != 0) || (down-up != 0);

hsp = lengthdir_x(spd * len, dir);
vsp = lengthdir_y(spd * len, dir);


x += hsp + force.x;
y += vsp + force.y;


force.x = lerp(force.x, 0, 0.02);
force.y = lerp(force.y, 0, 0.02);


if (isMoving) {
	force.x = hsp / 2;
	force.y = vsp / 2;
}
