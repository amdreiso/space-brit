
// Draw pause menu
drawPauseMenu();


// Debug
draw_stats();


drawConsole();


// Cursor stuff
if (Controller == CONTROLLER.Keyboard && instance_exists(Cursor)) {
	draw_sprite_ext(Cursor.sprite, 0, W_MOUSE.x, W_MOUSE.y, Cursor.scale, Cursor.scale, 0, c_white, 1);
}
