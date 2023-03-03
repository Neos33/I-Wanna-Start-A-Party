event_inherited();

if (state == 0) {
	scale += 0.08;
	
	if (scale >= 1) {
		scale = 1;
		state = -1;
		alarm_call(0, 5);
		alarm_call(3, 1);
	}
} else if (state == 1) {
	scale -= 0.05;
	
	if (scale <= 0) {
		scale = 0;
		state = -1;
		
		if (is_local_turn()) {
			with (focus_player) {
				event_perform(ev_other, ev_end_of_path)
			}
		}
		
		instance_destroy();
	}
}