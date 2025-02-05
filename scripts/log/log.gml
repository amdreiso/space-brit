function log(str, color = c_ltgray, font = fnt_console) {
	if (!instance_exists(Main)) return;
	
	if (array_length(Main.logs) > 24) {
		array_delete(Main.logs, array_length(Main.logs)-1, 1);
	}
	
	array_insert(Main.logs, 0, {
		str: str,
		color: color,
		font: font,
	});
}