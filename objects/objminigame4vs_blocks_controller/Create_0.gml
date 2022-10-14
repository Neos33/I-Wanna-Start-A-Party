event_inherited();

minigame_players = function() {
	with (objPlayerBase) {
		enable_shoot = false;
		choose_block = null;
		block_delay = 0;
		apply_delay = true;
	}
}

player_type = objPlayerPlatformer;

alarm_override(1, function() {
	alarm_inherited(1);
	objMinigame4vs_Blocks_Block.enabled = true;
});

alarm_override(11, function() {
	for (var i = 2; i <= global.player_max; i++) {
		var actions = check_player_actions_by_id(i);

		if (actions == null) {
			continue;
		}
	
		var player = focus_player_by_id(i);
		
		with (player) {
			if (block_delay > 0) {
				block_delay--;
				break;
			}
			
			if (apply_delay && choose_block != null && place_meeting(x, y + 1, objMinigame4vs_Blocks_Block)) {
				choose_block = null;
				block_delay = get_frames(random_range(0.1, 0.5));
				apply_delay = false;
				break;
			}
			
			var dir = -1;
			var block_jump = false;
			
			if (choose_block != null) {
				dir = point_direction(x, y, choose_block.x + 16, choose_block.bbox_top);
				block_jump = (dir >= 15 && dir <= 165);
			}
			
			if (choose_block == null || !instance_exists(choose_block) || (vspd > 0 && block_jump)) {
				choose_block = null;
				var choices = [];
				
				with (objMinigame4vs_Blocks_Block) {
					if (place_meeting(x, y, objBlock) || image_blend == c_red || point_distance(other.x, other.y, x + 16, other.y) > 160 || point_distance(other.x, other.y, other.x, bbox_bottom) > 160) {
						continue;
					}
					
					array_push(choices, id);
				}
				
				array_shuffle(choices);
				choose_block = array_pop(choices);
			}
			
			if (choose_block == null) {
				break;
			}
			
			var dist = point_distance(x, y, choose_block.x + 16, y);
			
			if (dist <= 3) {
				break;
			}
			
			var action = ((dir >= 0 && dir <= 90) || (dir >= 270 && dir <= 359)) ? actions.right : actions.left;
			action.press();
			
			if (vspd >= 0 && block_jump) {
				actions.jump.hold(20);
			}
			
			apply_delay = true;
		}
	}

	alarm_frames(11, 1);
});