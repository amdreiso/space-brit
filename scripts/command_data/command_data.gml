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


add(command("start", 0, function(args) {
	log("	     .->    (`-')  _                             <-. (`-')   (`-')  _    (`-')               ", make_color_hsv(0, 255, 255));
	log(" (`(`-')/`) ( OO).-/  <-.    _             .->      \\(OO )_  ( OO).-/    ( OO).->       .->   ", make_color_hsv(16, 255, 255));
	log(",-`( OO).',(,------.,--. )   \\-,-----.(`-')----. ,--./  ,-.)(,------.    /    '._  (`-')----. ", make_color_hsv(32, 255, 255));
	log("|  |\\  |  | |  .---'|  (`-')  |  .--./( OO).-.  '|   `.'   | |  .---'    |'--...__)( OO).-.  '", make_color_hsv(48, 255, 255));
	log("|  | '.|  |(|  '--. |  |OO ) /_) (`-')( _) | |  ||  |'.'|  |(|  '--.     `--.  .--'( _) | |  |", make_color_hsv(64, 255, 255));
	log("|  |.'.|  | |  .--'(|  '__ | ||  |OO ) \\|  |)|  ||  |   |  | |  .--'        |  |    \\|  |)|  |", make_color_hsv(80, 255, 255));
	log("|   ,'.   | |  `---.|     |'(_'  '--'\\  '  '-'  '|  |   |  | |  `---.       |  |     '  '-'  '", make_color_hsv(96, 255, 255));
	log("`--'   '--' `------'`-----'    `-----'   `-----' `--'   `--' `------'       `--'      `-----' ", make_color_hsv(112, 255, 255));
	log("                                 <-. (`-')_  (`-').->                    (`-')  _             ", make_color_hsv(128, 255, 255), fnt_console_bold);
	log("             _             .->      \\( OO) ) ( OO)_      .->      <-.    ( OO).-/             ", make_color_hsv(144, 255, 255), fnt_console_bold);
	log("             \\-,-----.(`-')----. ,--./ ,--/ (_)--\\_)(`-')----.  ,--. )  (,------.             ", make_color_hsv(160, 255, 255), fnt_console_bold);
	log("              |  .--./( OO).-.  '|   \\ |  | /    _ /( OO).-.  ' |  (`-') |  .---'             ", make_color_hsv(176, 255, 255), fnt_console_bold);
	log("             /_) (`-')( _) | |  ||  . '|  |)\\_..`--.( _) | |  | |  |OO )(|  '--.              ", make_color_hsv(192, 255, 255), fnt_console_bold);
	log("             ||  |OO ) \\|  |)|  ||  |\\    | .-._)   \\\\|  |)|  |(|  '__ | |  .--'              ", make_color_hsv(208, 255, 255), fnt_console_bold);
	log("            (_'  '--'\\  '  '-'  '|  | \\   | \\       / '  '-'  ' |     |' |  `---.             ", make_color_hsv(224, 255, 255), fnt_console_bold);
	log("               `-----'   `-----' `--'  `--'  `-----'   `-----'  `-----'  `------'             ", make_color_hsv(240, 255, 255), fnt_console_bold);
	log("");
	log("");
	log("ascii art from: https://patorjk.com/software/taag/", c_gray);
	log("");
	log("");
}));

add(command("set_player_pos", 2, function(args) {
	get_player().x = real(args[0]);
	get_player().y = real(args[1]);
}));

add(command("exit", 0, function(args) {
	game_end();
}));

add(command("get_item", 1, function(args) {
	var str = ItemData[? args[0]].name;
	
	log(str);
}));

add(command("kitty", 0, function(args) {
	log("Joana - tuxedo");
	log("Neve - white lioness");
	log("Nina - the judge");
}));

add(command("credits", 0, function(args) {
	log("Programming by Andrei Scatolin", c_aqua);
	log("Art by Andrei Scatolin", c_aqua);
	log("Audio Design by Andrei Scatolin", c_aqua);
	log("-------------------------------", c_red);
	log("Special Thanks to", c_yellow);
	log(" - Gabriel", $D851E0, fnt_console_bold);
	log(" - João", c_red, fnt_console_bold);
	log(" - Yury", c_green, fnt_console_bold);
}));

add(command("spaceship_add_item", 2, function(args) {
	if (!instance_exists(Spaceship)) {
		log("Spaceship doesn't exist");
		return;
	}
	
	repeat (real(args[1])) {
		Spaceship.inventoryAdd(real(args[0]));
	}
}));

add(command("die", 0, function(args) {
	if (!instance_exists(get_player())) {
		log($"{object_get_name(get_player())} doesn't exist");
		return;
	}
	
	get_player().hp = 0;
	get_player().dead = true;
}));

add(command("clear", 0, function(args) {
	Main.logs = [];
}));

add(command("planet", 0, function(args) {
	if (!instance_exists(Planet)) {
		log("There are no planets loaded");
		return;
	}
	
	set_planet(
		instance_nearest(x, y, Planet).components, vec2(0, 0)
	);
}));


}