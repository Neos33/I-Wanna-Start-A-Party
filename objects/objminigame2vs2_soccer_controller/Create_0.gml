event_inherited();

minigame_start = minigame2vs2_start;
minigame_players = function() {
	with (objPlayerBase) {
		enable_shoot = false;
		
		with (objMinigame2vs2_Soccer_Goal) {
			if ((x < 400 && other.x < 400) || (x > 400 && other.x > 400)) {
				other.goal = id;
				break;
			}
		}
	}
}

points_draw = true;
player_type = objPlayerPlatformer;

reset = -1;

alarm_override(1, function() {
	alarm_inherited(1);
});

alarm_override(11, function() {
	for (var i = 2; i <= global.player_max; i++) {
		var actions = check_player_actions_by_id(i);

		if (actions == null) {
			continue;
		}
	
		var player = focus_player_by_id(i);
		
		with (player) {
			if (place_meeting(x, y, objMinigame2vs2_Soccer_Ball)) {
				break;
			}
			
			var sign_middle = sign(xstart - 400);
			var is_keeper = place_meeting(xstart + 32 * sign_middle, ystart - 96, objMinigame2vs2_Soccer_Goal);
			var towards_goal = (sign(objMinigame2vs2_Soccer_Ball.hspeed) == sign_middle);
			var follow_x = (minigame2vs2_is_team(i, 0)) ? objMinigame2vs2_Soccer_Ball.bbox_left : objMinigame2vs2_Soccer_Ball.bbox_right;
			var follow_y = objMinigame2vs2_Soccer_Ball.y;
			var is_opposite_side = ((sign_middle == -1 && follow_x < 400) || (sign_middle == 1 && follow_x > 400));
			
			if (!is_keeper && towards_goal && is_opposite_side) {
				break;
			}
			
			follow_x += irandom_range(-16, 16);
			follow_y += irandom_range(-16, 16);
			
			if (is_keeper && (!towards_goal || collision_circle(x, y, 128, objMinigame2vs2_Soccer_Ball, true, true) == noone)) {
				follow_x = xstart;
				follow_y = ystart;
			}
			
			var dist = point_distance(x, y, follow_x, follow_y);
			
			if (dist <= 3) {
				break;
			}
			
			var dir = point_direction(x, y, follow_x, follow_y);
			
			if (abs(angle_difference(dir, 270)) >= 16) {
				var dist_to_up = abs(angle_difference(dir, 90));
				
				if (dist_to_up > 4) {
					var action = (dir >= 90 && dir <= 270) ? actions.left : actions.right;
					action.press();
				}
		
				if (vspd >= 0 && dist_to_up < 30) {
					actions.jump.hold(irandom_range(3, 10));
				}
			}
		}
	}

	alarm_frames(11, 1);
});