#region Events
function ChanceTimeEvent(dialogue, action, amount = null, to_left = null) constructor {
	dialogue = string_replace(dialogue, "{p1}", "{COLOR,0000FF}[p1]{COLOR,FFFFFF}");
	dialogue = string_replace(dialogue, "{p2}", "{COLOR,0000FF}[p2]{COLOR,FFFFFF}");
	self.dialogue = language_get_text("PARTY_CHANCE_TIME_LOOKS_LIKE") + " " + dialogue;
	self.action = action;
	self.amount = amount;
	self.to_left = to_left;
	self.final_action = function() {
		with (objChanceTime) {
			player_infos = [];
			players = [];
			
			for (var i = 0; i < array_length(player_ids); i++) {
				array_push(player_infos, player_info_by_turn(player_ids[i] + 1));
				array_push(players, focus_player_by_turn(player_ids[i] + 1));
			}

			other.action(other.amount, other.to_left);
		}
	}
}

function shines_coins_exchange_chance_time() {
	with (objChanceTime) {
		player_shines_diff = abs(player_infos[1].shines - player_infos[0].shines);
		player_coins_diff = abs(player_infos[1].coins - player_infos[0].coins);
		
		if (player_shines_diff == 0 && player_coins_diff == 0) {
			no_changes = true;
			advance_chance_time();
			return;
		}
	
		if (player_shines_diff == 0) {
			coins_exchange_chance_time();
		} else if (player_coins_diff == 0) {
			shines_exchange_chance_time();
		} else {
			has_less_shines = (player_infos[0].shines < player_infos[1].shines);
			has_less_coins = (player_infos[0].coins < player_infos[1].coins);
			
			change_shines(-player_shines_diff, ShineChangeType.Lose, player_infos[has_less_shines].turn).final_action = function() {
				change_shines(player_shines_diff, ShineChangeType.Spawn, player_infos[!has_less_shines].turn).final_action = function() {
					change_coins(-player_coins_diff, CoinChangeType.Lose, player_infos[has_less_coins].turn).final_action = function() {
						change_coins(player_coins_diff, CoinChangeType.Gain, player_infos[!has_less_coins].turn).final_action = objChanceTime.advance_chance_time;
					}
				}
			}
		}
	}
}

function shines_exchange_chance_time() {
	with (objChanceTime) {
		player_shines_diff = abs(player_infos[1].shines - player_infos[0].shines);
		
		if (player_shines_diff == 0) {
			no_changes = true;
			advance_chance_time();
			return;
		}
		
		has_less_shines = (player_infos[0].shines < player_infos[1].shines);
		
		change_shines(-player_shines_diff, ShineChangeType.Lose, player_infos[has_less_shines].turn).final_action = function() {
			change_shines(player_shines_diff, ShineChangeType.Spawn, player_infos[!has_less_shines].turn).final_action = objChanceTime.advance_chance_time;
		}
	}
}

function coins_exchange_chance_time() {
	with (objChanceTime) {
		player_coins_diff = abs(player_infos[1].coins - player_infos[0].coins);
		
		if (player_coins_diff == 0) {
			no_changes = true;
			advance_chance_time();
			return;
		}
		
		has_less_coins = (player_infos[0].coins < player_infos[1].coins);
		
		change_coins(-player_coins_diff, CoinChangeType.Lose, player_infos[has_less_coins].turn).final_action = function() {
			change_coins(player_coins_diff, CoinChangeType.Gain, player_infos[!has_less_coins].turn).final_action = objChanceTime.advance_chance_time;
		}
	}
}

function shines_give_chance_time(amount, to_left) {
	with (objChanceTime) {
		use_amount = min(amount, player_infos[to_left].shines);
		use_to_left = to_left;
	
		if (use_amount == 0) {
			no_changes = true;
			advance_chance_time();
			return;
		}
		
		change_shines(-use_amount, ShineChangeType.Lose, player_infos[use_to_left].turn).final_action = function() {
			change_shines(use_amount, ShineChangeType.Spawn, player_infos[!use_to_left].turn).final_action = objChanceTime.advance_chance_time;
		}
	}
}

function coins_give_chance_time(amount, to_left) {
	with (objChanceTime) {
		use_amount = min(amount, player_infos[to_left].coins);
		use_to_left = to_left;
	
		if (use_amount == 0) {
			no_changes = true;
			advance_chance_time();
			return;
		}
		
		change_coins(-use_amount, CoinChangeType.Lose, player_infos[use_to_left].turn).final_action = function() {
			change_coins(use_amount, CoinChangeType.Gain, player_infos[!use_to_left].turn).final_action = objChanceTime.advance_chance_time;
		}
	}
}

events = [
	new ChanceTimeEvent(language_get_text("PARTY_CHANCE_TIME_EXCHANGE_SHINES_COINS", ["{Player 1}", "{p1}"], ["{Player 2}", "{p2}"], ["{Shine}", "{SPRITE,sprShine,0,0,-2,0.5,0.5}"], ["{Coins}", draw_coins_price()]), shines_coins_exchange_chance_time),
	new ChanceTimeEvent(language_get_text("PARTY_CHANCE_TIME_EXCHANGE_SHINES", ["{Player 1}", "{p1}"], ["{Player 2}", "{p2}"], ["{Shine}", "{SPRITE,sprShine,0,0,-2,0.5,0.5}"]), shines_exchange_chance_time),
	new ChanceTimeEvent(language_get_text("PARTY_CHANCE_TIME_EXCHANGE_COINS", ["{Player 1}", "{p1}"], ["{Player 2}", "{p2}"], ["{Coins}", draw_coins_price()]), coins_exchange_chance_time),
	new ChanceTimeEvent(language_get_text("PARTY_CHANCE_TIME_GIVE_1_SHINE_P2_P1", ["{Player 2}", "{p2}"], ["{Shine}", "{SPRITE,sprShine,0,0,-2,0.5,0.5}"], ["{Player 1}", "{p1}"]), shines_give_chance_time, 1, true),
	new ChanceTimeEvent(language_get_text("PARTY_CHANCE_TIME_GIVE_1_SHINE_P1_P2", ["{Player 1}", "{p1}"], ["{Shine}", "{SPRITE,sprShine,0,0,-2,0.5,0.5}"], ["{Player 2}", "{p2}"]), shines_give_chance_time, 1, false),
	new ChanceTimeEvent(language_get_text("PARTY_CHANCE_TIME_GIVE_2_SHINES_P2_P1", ["{Player 2}", "{p2}"], ["{Shine}", "{SPRITE,sprShine,0,0,-2,0.5,0.5}"], ["{Player 1}", "{p1}"]), shines_give_chance_time, 2, true),
	new ChanceTimeEvent(language_get_text("PARTY_CHANCE_TIME_GIVE_2_SHINES_P1_P2", ["{Player 1}", "{p1}"], ["{Shine}", "{SPRITE,sprShine,0,0,-2,0.5,0.5}"], ["{Player 2}", "{p2}"]), shines_give_chance_time, 2, false),
	new ChanceTimeEvent(language_get_text("PARTY_CHANCE_TIME_GIVE_30_COINS_P2_P1", ["{Player 2}", "{p2}"], ["{30 coins}", draw_coins_price(30)], ["{Player 1}", "{p1}"]), coins_give_chance_time, 30, true),
	new ChanceTimeEvent(language_get_text("PARTY_CHANCE_TIME_GIVE_30_COINS_P1_P2", ["{Player 1}", "{p1}"], ["{30 coins}", draw_coins_price(30)], ["{Player 2}", "{p2}"]), coins_give_chance_time, 30, false)
];
#endregion

focus_player = focused_player();
network_id = focus_player.network_id;
player_info = player_info_by_turn();
prev_player_positions = store_player_positions();
current_follow = null;
current_flag = 0;
started = false;
player_ids = array_create(2, null);
player_names = array_create(2, "");
event = null;
show_others = false;
no_changes = false;
rotate_turn = true;

function begin_chance_time() {
	if (is_local_turn()) {
		start_dialogue([
			language_get_text("PARTY_CHANCE_TIME_WELCOME"),
			new Message(language_get_text("PARTY_CHANCE_TIME_PLAYERS_INVOLVED"),, objChanceTime.advance_chance_time)
		]);
	}
}

function advance_chance_time() {
	var b = instance_create_layer(focus_player.x, focus_player.y - 37, "Actors", objChanceTimeBox);
	b.flag = current_flag;
	global.actions.jump.consume();
	
	if (is_local_turn()) {
		switch (current_flag) {
			case 0: //Spawns the first player box
				b.sprites = all_player_sprites();
				break;
			
			case 1: //Spawns the second player box
				b.sprites = all_player_sprites();
				var other_sprite = objChanceTimeChoice.sprite;
				var del_index = array_get_index(b.sprites, other_sprite);
				array_delete(b.sprites, del_index, 1);
				break;
				
			case 2: //Announces the player results
				instance_destroy(b);
				var names = all_player_names();
				player_names = [];
				
				for (var i = 0; i < array_length(player_ids); i++) {
					array_push(player_names, names[player_ids[i]]);
				}
			
				start_dialogue([
					language_get_text("PARTY_CHANCE_TIME_CHOSEN_PLAYERS", ["{Color}", "{COLOR,0000FF}"], ["{Player 1}", player_names[0]], ["{Color}", "{COLOR,FFFFFF}"], ["{Color}", "{COLOR,0000FF}"], ["{Player 2}", player_names[1]], ["{Color}", "{COLOR,FFFFFF}"]),
					new Message(language_get_text("PARTY_CHANCE_TIME_WONDER_EXCHANGE"),, function() {
						with (objChanceTime) {
							current_flag++;
							advance_chance_time();
						}
					})
				]);
				break;
				
			case 3: //Spawns the exchange box
				b.sprites = array_sequence(0, sprite_get_number(sprChanceTimeExchanges));
				b.indexes = true;
				break;
				
			case 4: //Announces the exchange result and teleports the players onto position
				instance_destroy(b);
				event.dialogue = string_replace(event.dialogue, "[p1]", player_names[0]);
				event.dialogue = string_replace(event.dialogue, "[p2]", player_names[1]);
				
				start_dialogue([
					language_get_text("PARTY_CHANCE_TIME_RESULTS"),
					new Message(event.dialogue,, objChanceTime.reposition_chance_time)
				]);
				break;
				
			case 5: //Ends the chance time
				instance_destroy(b);
				
				if (!no_changes) {
					var dialogue = language_get_text("PARTY_CHANCE_TIME_THATS_IT");
				} else {
					var dialogue = language_get_text("PARTY_CHANCE_TIME_NOTHING_CHANGED")
				}
				
				start_dialogue([
					new Message(dialogue,, objChanceTime.end_chance_time)
				]);
				break;
		}

		if (instance_exists(b)) {
			buffer_seek_begin();
			buffer_write_action(ClientTCP.SpawnChanceTimeBox);
			buffer_write_array(buffer_u32, b.sprites);
			buffer_write_data(buffer_bool, b.indexes);
			network_send_tcp_packet();
		} else {
			focus_player.can_jump = false;
		}
	}
	
	return b;
}

function reposition_chance_time() {
	with (objChanceTimeChoice) {
		if (flag < 2) {
			instance_destroy();
		}
	}
	
	try {
		//Puts the chosen players in its respective positions
		for (var i = 0; i < array_length(player_ids); i++) {
			var player = focus_player_by_turn(player_ids[i] + 1);
			player.image_xscale = 1;
		
			if (i == 0) {
				player.x = current_follow.x - 48;
			} else {
				player.x = current_follow.x + 48;
			}
		
			player.y = current_follow.y;
		}
	} catch (ex) {
		log_error(ex);
	}
	
	show_others = true;
	
	switch_camera_target(current_follow.x, current_follow.y).final_action = function() {
		if (is_local_turn()) {
			with (objChanceTime) {
				current_flag++;
				event.final_action();
			}
		}
	}
	
	if (is_local_turn()) {
		var player_info = player_info_by_id(focus_player.network_id);
		
		if (!array_contains(player_ids, player_info.turn - 1)) {
			focus_player.y += 32;
		}
		
		buffer_seek_begin();
		buffer_write_action(ClientTCP.RepositionChanceTime);
		network_send_tcp_packet();
	}
}

function end_chance_time() {
	//Repositions all the players to their previous positions
	for (var i = 1; i <= global.player_max; i++) {
		var player = focus_player_by_turn(i);
		var prev_pos = prev_player_positions[i - 1];
		player.draw = true;
		player.x = prev_pos.x;
		player.y = prev_pos.y;
	}
	
	current_follow = null;
	started = false;
	instance_destroy(objChanceTimeChoice);
	
	switch_camera_target(focus_player.x, focus_player.y).final_action = function() {
		music_fade();
		
		with (objChanceTime) {
			alarm_call(1, 1);
		}
	}
	
	if (is_local_turn()) {
		buffer_seek_begin();
		buffer_write_action(ClientTCP.EndChanceTime);
		network_send_tcp_packet();
	}
}

music_fade();

alarms_init(4);

alarm_create(function() {
	music_pause();
	music_change(bgmChanceTime);

	with (focus_player) {
		with (objPlayerReference) {
			if (reference == 1) {
				other.x = x + 17;
				other.y = y + 23;
			}
		}
	}

	current_follow = {x: focus_player.x, y: focus_player.y};

	switch_camera_target(focus_player.x, focus_player.y).final_action = function() {
		with (objChanceTime) {
			alarm_call(2, 0.5);
		}
	}

	started = true;
});

alarm_create(function() {
	music_stop();
	music_resume();
	audio_sound_gain(global.music_current, 1, 0);

	if (rotate_turn) {
		turn_next();
	}
	
	instance_destroy();
});

alarm_create(function() {
	show_popup(language_get_text("PARTY_CHANCE_TIME_POPUP"));
	alarm_call(3, 2);
});

alarm_create(function() {
	begin_chance_time();
});

alarm_call(0, 1);