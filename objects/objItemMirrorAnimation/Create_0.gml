event_inherited();

if (is_local_turn()) {
	with (objSpaces) {
		if (image_index == SpaceType.Shine) {
			objPlayerBoard.x = x + 16;
			objPlayerBoard.y = y + 16;
			break;
		}
	}

	with (focused_player()) {
		event_perform(ev_other, ev_end_of_path);	
	}
}

alarm[0] = 1;