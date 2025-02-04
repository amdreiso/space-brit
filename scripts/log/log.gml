function log(str) {
	if (!instance_exists(Main)) return;
	
	if (array_length(Main.logs) > 27) {
		array_delete(Main.logs, array_length(Main.logs)-1, 1);
	}
	
	array_insert(Main.logs, 0, str);
}