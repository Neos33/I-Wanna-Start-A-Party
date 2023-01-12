event_inherited();

space_shine = null;
space_current = {x: focus_player.x, y: focus_player.y};

state = 0;
scale = 0;
angle = 0;

if (room != rBoardPallet) {
	with (objSpaces) {
		if (image_index == SpaceType.Shine) {
			other.space_shine = id;
			break;
		}
	}
} else {
	var animation = id;
		
	with (objBoardPalletPokemon) {
		if (!has_shine()) {
			continue;
		}
			
		var space_record = infinity;
		
		with (objSpaces) {
			if (image_index != SpaceType.PathEvent) {
				continue;
			}
				
			var dist = point_distance(x + 16, y + 16, other.x, other.y);
						
			if (dist < space_record) {
				space_record = dist;
				animation.space_shine = id;
			}
		}

		break;
	}
}
	
space_shine = {x: space_shine.x + 16, y: space_shine.y + 16};

alarms_init(3);

alarm_create(function() {
	if (is_local_turn()) {
		with (focus_player) {
			board_jump();
		}
	}
	
	alarm_call(1, 0.3);
});

alarm_create(function() {
	if (is_local_turn()) {
		with (focus_player) {
			var diff_y = (jump_y - y);
			jump_y = other.space_shine.y;
			x = other.space_shine.x;
			y = other.space_shine.y - diff_y;
		}
	}
	
	alarm_call(2, 1);
});

alarm_create(function() {
	state = 1;
});