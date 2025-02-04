function command_data(){

globalvar CommandData;
CommandData = [];

var command = function(name, argc, fn) {
	return {
		name: name,
		argc: argc,
		fn: fn,
	}
}

var add = function(val) {
	array_push(CommandData, val);
}

add(command("set_player_pos", 2, function(args) {
	if (array_length(args) != 2) {
		log("Not enough argument!");
		return;
	}
	
	get_player().x = real(args[0]);
	get_player().y = real(args[1]);
}));

add(command("exit", 0, function() {
	game_end();
}));

add(command("kitty", 0, function() {
	log("Joana");
	log("Neve");
	log("Nina");
}));


}