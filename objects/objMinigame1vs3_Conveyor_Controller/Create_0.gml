event_inherited();

minigame_start = minigame1vs3_start;
minigame_players = function() {
	with (objPlayerBase) {
		enable_shoot = false;
		move_delay_timer = 0;
		chosed_conveyor = -1;
	}
}

minigame_time = 20;
minigame_time_end = function() {
	if (!minigame1vs3_lost()) {
		minigame1vs3_points();
	} else {
		minigame4vs_points(minigame1vs3_solo().network_id);
	}
	
	minigame_finish();
	
	if audio_is_playing(sndMinigame1vs3_Conveyor_MovingLoop)
		audio_stop_sound(sndMinigame1vs3_Conveyor_MovingLoop);
}

action_end = function() {
	with (objMinigame1vs3_Conveyor_Conveyor) {
		sprite_index = sprMinigame1vs3_Conveyor_ConveyorStill;
		spd = 0;
	}
}

player_type = objPlayerPlatformer;

part_system = part_system_create();
part_system_depth(part_system, -10000);

part_type = part_type_create();
part_type_sprite(part_type, sprMinigame1vs3_Conveyor_Particle, false, false, false);
part_type_size(part_type, 1, 1.5, -0.02, 0);
part_type_speed(part_type, 1.5, 3, 0, 0); 
part_type_direction(part_type, 60, 120, 0, 0);
part_type_life(part_type, 100, 100);

part_emitter = part_emitter_create(part_system);
part_emitter_region(part_system, part_emitter, 0, 800, 620, 620, ps_shape_rectangle, ps_distr_linear);
part_emitter_stream(part_system, part_emitter, part_type, 1);

alarm_override(11, function() {
	for (var i = 2; i <= global.player_max; i++) {
		var actions = check_player_actions_by_id(i);

		if (actions == null) {
			continue;
		}
	
		var player = focus_player_by_id(i);
	
		with (player) {
			if (minigame1vs3_is_solo(i)) {
				if (move_delay_timer > 0) {
					move_delay_timer--;
					break;
				}
			
				if (chosed_conveyor == -1) {
					chosed_conveyor = choose(320, 384, 448) + 16;
				}
			
				if (point_distance(x, y, chosed_conveyor, y) > 3) {
					var dir = floor(point_direction(x, y, chosed_conveyor, y));
					var action = (dir == 0) ? actions.right : actions.left;
					action.hold(6);
				} else {
					actions.jump.hold(15);
					move_delay_timer = irandom_range(get_frames(0.1), get_frames(0.25));
					chosed_conveyor = -1;
				}
			} else {
				var dist = point_distance(x, y, 400, y);
				var sprite = objMinigame1vs3_Conveyor_Conveyor.sprite_index;
				
				switch (objMinigame1vs3_Conveyor_Conveyor.sprite_index) {
					case sprMinigame1vs3_Conveyor_ConveyorStill: var action = null; break;
					case sprMinigame1vs3_Conveyor_ConveyorRight:
						if (dist > 64 && x < 400) {
							var action = actions.right;
						} else {
							var action = actions.left;
						}
						break;
						
					case sprMinigame1vs3_Conveyor_ConveyorLeft:
						if (dist > 64 && x > 400) {
							var action = actions.left;
						} else {
							var action = actions.right;
						}
						break;
				}
				
				if (sprite == sprMinigame1vs3_Conveyor_ConveyorStill) {
					var action = null;
				}
			
				if (action != null) {
					action.hold(irandom_range(get_frames(0.1), get_frames(0.45)));
				} else {
					if (dist > 64) {
						var dir = point_direction(x, y, 400, y);
						var action = (dir == 0) ? actions.right : actions.left;
						actions.left.release();
						actions.right.release();
						action.hold(irandom_range(get_frames(0.1), get_frames(0.2)));
					}
				}
			}
		}
	}

	alarm_frames(11, 1);
});