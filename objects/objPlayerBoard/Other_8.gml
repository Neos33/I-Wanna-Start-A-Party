if (follow_path != null && path_exists(follow_path)) {
	path_delete(follow_path);
	follow_path = null;
}

var space = instance_place(x, y, objSpaces);
var passing = false;

with (space) {
	passing = space_passing_event();
}

if (passing) {
	exit;
}

global.dice_roll--;

buffer_seek_begin();
buffer_write_action(ClientTCP.LessRoll);
network_send_tcp_packet();

if (global.dice_roll > 0) {
	board_advance();
} else {
	with (space) {
		space_finish_event();
	}
	
	//turn_next();
}