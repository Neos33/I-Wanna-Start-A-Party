event_inherited();

minigame_start = minigame2vs2_start;
minigame_time = 40;
points_draw = true;
player_type = objPlayerPlatformer;
buttons_outside_list = [];
buttons_inside_list = [];

repeat (50) {
	array_push(buttons_outside_list, irandom(5));
	array_push(buttons_inside_list, irandom(5));
}

buttons_outside_current = 0;
buttons_inside_current = 0;

alarm_override(1, function() {
	alarm_inherited(1);
	alarm_instant(4);
	alarm_instant(5);
});

alarm_create(4, function() {
	var index = 0;

	with (objMinigame2vs2_Buttons_Button) {
		if (inside) {
			if (index == other.buttons_inside_list[other.buttons_inside_current]) {
				image_index = 1;
				other.buttons_inside_current++;
				break;
			}
		
			index++;
		}
	}

	//audio_play_sound(sndBlockChange, 0, false);
});

alarm_create(5, function() {
	var index = 0;

	with (objMinigame2vs2_Buttons_Button) {
		if (!inside) {
			if (index == other.buttons_outside_list[other.buttons_outside_current]) {
				image_index = 1;
				other.buttons_outside_current++;
				break;
			}
		
			index++;
		}
	}

	//audio_play_sound(sndBlockChange, 0, false);
});

alarm_override(11, function() {
	for (var i = 2; i <= global.player_max; i++) {
		var actions = check_player_actions_by_id(i);

		if (actions == null) {
			continue;
		}
		
		var player = focus_player_by_id(i);
		var player_info = player_info_by_id(i);
	
		with (objMinigame2vs2_Buttons_Button) {
			if (inside == (player_info.space == other.info.player_colors[0]) || image_index == 0) {
				instance_deactivate_object(id);
			}
		}
	
		if (!instance_exists(objMinigame2vs2_Buttons_Button)) {
			instance_activate_object(objMinigame2vs2_Buttons_Button);
			continue;
		}
	
		var near = instance_nearest(player.x, player.y, objMinigame2vs2_Buttons_Button);
		instance_activate_object(objMinigame2vs2_Buttons_Button);
		
		with (player) {
			var other_x = near.x + 20 * near.image_xscale;
			var other_y = near.y + sprite_yoffset;
		
			if (point_distance(x, y, other_x, other_y) > 224 && point_distance(x, y, other_x, other_y) > point_distance(teammate.x - 1, teammate.y - 7, other_x, other_y)) {
				break;
			}
		
			if (point_distance(x, y, other_x, other_y) <= 6) {
				actions.shoot.press();
				break;
			}
		
			mp_grid_path(other.grid, path, x, y, other_x, other_y, true);
			var dir = point_direction(x, y, path_get_point_x(path, 1), path_get_point_y(path, 1));
			
			if (abs(angle_difference(dir, 270)) >= 16) {
				var dist_to_up = abs(angle_difference(dir, 90));
				
				if (dist_to_up > 4) {
					var action = (dir >= 90 && dir <= 270) ? actions.left : actions.right;
					action.press();
				}
		
				if (--jump_delay_timer <= 0 && dist_to_up < 45) {
					actions.jump.hold(6);
					jump_delay_timer = 8;
				}
			}
		}
	}

	alarm_frames(11, 1);
});