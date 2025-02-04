function set_cursor(state){
	if (!instance_exists(Cursor)) return;
	Cursor.state = state;
}