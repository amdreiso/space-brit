function draw_stats(){

	if (!Debug) return;

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var sep = 14;

	draw_text(0, 0, $"{GameInfo.name} made by {GameInfo.author}");
	draw_text(0, sep, $"version: {GameInfo.version[0]}.{GameInfo.version[1]}.{GameInfo.version[2]} {GameInfo.release}");
	draw_text(0, 2 * sep, $"{fps} fps");
	draw_text(0, 3 * sep, $"x: {x} y: {y}");
	draw_text(0, 4 * sep, $"star_x: {floor(x / Stars.chunk)} star_y: {floor(y / Stars.chunk)}");

}