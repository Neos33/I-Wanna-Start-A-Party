if (instance_number(object_index) > 1) {
	instance_destroy();
	exit;
}

fade_start = true;
fade_alpha = 1;

with (objPlayerBase) {
	change_to_object(objPlayerBoard);
}

//Board controllers
global.board_started = false;
global.board_turn = 1;
global.player_turn = 1;
global.dice_roll = 0;
global.choice_selected = -1;
global.item_choice = false;
global.board_day = true;

//Board values
global.shine_spawn_count = 1;
global.shine_price = 20;
global.min_shop_coins = 5;
global.min_blackhole_coins = 5;

//Bonus values
for (var i = 0; i < array_length(global.bonus_shines); i++) {
	global.bonus_shines[i].reset_scores();
}

for (var i = 0; i < global.player_max; i++) {
	global.bonus_shines_ready[i] = false;
}

//Minigame values
minigame_info_reset();
global.minigame_type_history = [];
global.minigame_history = [];

tell_choices = false;
cpu_wait = true;
cpu_staled = true;
cpu_performed = true;
cpu_item = -1;

//Baba's Board
tile_image_speed = 0.12;
tile_image_index = 0;

//Pallet's Board
global.pokemon_price = 15;

alarms_init(12);

alarm_create(function() {
	event_perform(ev_other, ev_room_start);
});

alarm_create(function() {
	for (var i = 0; i < array_length(global.minigame_info.players_won); i++) {
		var player_won = global.minigame_info.players_won[i];
		change_coins(10, CoinChangeType.Gain, player_info_by_id(player_won).turn);
	}

	alarm_call(2, 3.3);
});

alarm_create(function() {
	minigame_info_placement();

	for (var i = 0; i < global.player_max; i++) {
		var player_info = places_minigame_info[i];
		var order = places_minigame_order[i];
			
		with (player_info) {
			target_draw_x = 400 - draw_w / 2;
			target_draw_y = 79 + (draw_h + 30) * (order - 1);
		}
	}

	alarm_call(3, 1.5);
});

alarm_create(function() {});

alarm_create(function() {
	if (is_local_turn()) {
		turn_next();
	}
});

alarm_create(11, function() {
	if (global.player_id != 1) {
		return;
	}

	cpu_staled = false;
	cpu_performed = false;
	alarm_frames(11, 1);

	var stale_action = function(seconds) {
		if (!cpu_wait || cpu_staled || cpu_performed) {
			return;
		}
	
		alarm_call(11, seconds);
		cpu_wait = false;
		cpu_staled = true;
	}

	var perform_action = function(action) {
		if (cpu_staled || cpu_performed) {
			return;
		}
	
		action.press();
		cpu_wait = true;
		cpu_performed = true;
	}

	var stale_frames = random_range(0.1, 0.3);

	if (global.board_started) {
		var player_info = player_info_by_turn();
		var actions = check_player_actions_by_id(player_info.network_id);

		if (actions == null) {
			exit;
		}
	
		if (instance_exists(objTurnChoices) && objTurnChoices.can_choose()) {
			if (player_info.item_used != null) {
				cpu_item = -1;
			}
		
			if (cpu_item == -1 && player_info.item_used == null && array_count(player_info.items, null) < 3) {
				var use_percentage = array_create(3, 0);
				
				for (var i = 0; i < 3; i++) {
					var item = player_info.items[i];
			
					if (item == null || !item.use_criteria()) {
						continue;
					}
				
					use_percentage[i] = irandom_range(0, 100);
				}
			
				if (array_count(use_percentage, 0) < 3) {
					var max_percentage = -infinity;
			
					for (var i = 0; i < 3; i++) {
						max_percentage = max(max_percentage, use_percentage[i]);
					}
				
					var most_percentage = [];
				
					for (var i = 0; i < 3; i++) {
						if (use_percentage[i] == max_percentage) {
							array_push(most_percentage, i);
						}
					}
				
					array_shuffle(most_percentage);
					var chosen_percentage = most_percentage[0];
					cpu_item = chosen_percentage;
				}
			}
		
			if (cpu_item == -1) {
				stale_action(stale_frames);
			
				if (objTurnChoices.option_selected == 0) {
					perform_action(actions.jump);
				} else {
					perform_action(actions.up);
				}
			} else {
				stale_action(stale_frames);
			
				if (objTurnChoices.option_selected == 0) {
					perform_action(actions.down);
				} else {
					perform_action(actions.jump);
				}
			}
		}
	
		if (instance_exists(objMultipleChoices)) {
			stale_action(stale_frames);
		
			if (global.item_choice) {
				if (global.choice_selected == cpu_item) {
					perform_action(actions.jump);
				} else {
					perform_action(actions.right);
				}
			}
		}
	
		if (instance_exists(objBox)) {
			stale_action(random_range(0.5, 1.5));
			perform_action(actions.jump);
		}
	
		if (instance_exists(objPathChange)) {
			perform_action(actions.jump);
		}
	
		//if (instance_exists(objDialogue)) {
		//	if (!objDialogue.text_display.text.tw_active) {
		//		stale_action(1);
		//		perform_action(actions.jump);
		//	} else {
		//		perform_action(actions.jump);
		//	}
		//}

		var keys = variable_struct_get_names(actions);
		perform_action(actions[$ keys[irandom(array_length(keys) - 1)]]);
	} else if (!instance_exists(objDialogue)) {
		for (var i = 2; i <= global.player_max; i++) {
			var actions = check_player_actions_by_id(i);
		
			if (actions == null) {
				continue;
			}
		
			actions.jump.press();
		}
	}
});

alarm_frames(11, 1);