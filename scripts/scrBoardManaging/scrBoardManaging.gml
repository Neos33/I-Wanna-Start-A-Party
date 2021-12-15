enum SpaceType {
	Blue,
	Red,
	Green,
	Pink,
	Purple,
	Orange,
	Yellow,
	Dark,
	Cyan,
	Shine,
	EvilShine,
	PathChange
}

randomize();

function PlayerBoard(network_id, turn) constructor {
	self.network_id = network_id;
	self.turn = turn;
	self.shines = 0;
	self.coins = 0;
	self.items = array_create(3, null);
	
	static toString = function() {
		return string(self.turn);
	}
}

function is_player_turn(id = global.player_id) {
	return (global.player_turn == id);
}

function focus_player() {
	if (is_player_turn()) {
		return objPlayerBase;
	} else {
		with (objNetworkPlayer) {
			if (network_id == global.player_turn) {
				return id;
			}
		}
	}
}

function board_start() {
	if (is_player_turn()) {
		if (!global.board_started) {
			choose_shine();
			board_advance();
		} else {
			show_dice();
		}
	}
}

function board_advance() {
	with (objPlayerBoard) {
		follow_path = path_add();
		var path_total = path_get_number(global.path_current);
		var current_x = path_get_point_x(global.path_current, global.path_number);
		var current_y = path_get_point_y(global.path_current, global.path_number);
		var next_x, next_y;
		path_add_point(follow_path, current_x, current_y, 100);
	
		if (global.path_direction == 1) {
			next_x = path_get_point_x(global.path_current, global.path_number + global.path_direction);
			next_y = path_get_point_y(global.path_current, global.path_number + global.path_direction);
			path_add_point(follow_path, next_x, next_y, 100);	
			array_push(space_stack, {prev_path: global.path_current, prev_number: global.path_number, prev_x: current_x, prev_y: current_y});
		
			if (array_length(space_stack) > 10) {
				array_delete(space_stack, 0, 1);
			}
		
			global.path_number = (global.path_number + global.path_direction + path_total) % path_total;
		} else if (global.path_direction == -1) {
			var reverse = array_pop(space_stack);
			next_x = reverse.prev_x;
			next_y = reverse.prev_y;
			path_add_point(follow_path, reverse.prev_x, reverse.prev_y, 100);
			global.path_current = reverse.prev_path;
			global.path_number = reverse.prev_number;
		}

		image_xscale = (next_x >= current_x) ? 1 : -1;
		path_set_closed(follow_path, false);
		path_start(follow_path, max_speed, path_action_stop, true);
	}
}

function show_dice() {
	instance_create_layer(objPlayerBoard.x - 16, objPlayerBoard.y - 69, "Actors", objDice);
	buffer_seek_begin();
	buffer_write_from_host(false);
	buffer_write_action(Client_TCP.ShowDice);
	buffer_write_data(buffer_s16, objDice.x);
	buffer_write_data(buffer_s16, objDice.y);
	network_send_tcp_packet();
}

function roll_dice() {
	if (global.player_turn != global.player_id) {
		return;
	}
	
	global.dice_roll = objDice.roll;
	//Fix number not showing for other players
	instance_create_layer(objDice.x + 16, objDice.y + 16, "Actors", objDiceRoll);
	instance_destroy(objDice);
	
	buffer_seek_begin();
	buffer_write_from_host(false);
	buffer_write_action(Client_TCP.RollDice);
	buffer_write_data(buffer_u8, global.dice_roll);
	network_send_tcp_packet();
}

function next_turn() {
	global.player_turn += 1;
	
	if (global.player_turn > 2) {
		global.player_turn = 1;
	}
	
	buffer_seek_begin();
	buffer_write_from_host(false);
	buffer_write_action(Client_TCP.NextTurn);
	buffer_write_data(buffer_u8, global.player_turn);
	network_send_tcp_packet();
}

function choose_shine() {
	if (global.shine_spotted) {
		return;
	}
	
	var choices = [];
	
	with (objSpaces) {
		if (space_shine) {
			array_push(choices, id);
		}
	}
	
	var prev_space = null;
	
	for (var i = 0; i < array_length(choices); i++) {
		var space = choices[i];
		
		if (space.image_index == SpaceType.Shine) {
			space.image_index = SpaceType.Blue;
			prev_space = space;
		}
	}
	
	//Fix shine not appearing in random places
	var space = array_pop(choices);
	
	if (space == prev_space) {
		space = array_pop(choices);
	}
	
	space.image_index = SpaceType.Shine;
	
	buffer_seek_begin();
	buffer_write_from_host(false);
	buffer_write_action(Client_TCP.ChooseShine);
	buffer_write_data(buffer_s16, space.x);
	buffer_write_data(buffer_s16, space.y);
	network_send_tcp_packet();
}

function get_player_info(id = global.player_id) {
	with (objPlayerInfo) {
		if (player_info.network_id == id) {
			return player_info;
		}
	}
}

function change_shines(amount, id = global.player_id) {
	var my_info = get_player_info(id);
	my_info.shines += amount;
	my_info.shines = clamp(my_info.shines, 0, 99);
	
	if (id == global.player_id) {
		buffer_seek_begin();
		buffer_write_from_host(false);
		buffer_write_action(Client_TCP.ChangeShines);
		buffer_write_data(buffer_u8, id);
		buffer_write_data(buffer_u8, my_info.shines);
		network_send_tcp_packet();
	}
}

function change_coins(amount, id = global.player_id) {
	var my_info = get_player_info(id);
	my_info.coins += amount;
	my_info.coins = clamp(my_info.coins, 0, 999);
	
	if (id == global.player_id) {
		buffer_seek_begin();
		buffer_write_from_host(false);
		buffer_write_action(Client_TCP.ChangeCoins);
		buffer_write_data(buffer_u8, id);
		buffer_write_data(buffer_u8, my_info.coins);
		network_send_tcp_packet();
	}
}