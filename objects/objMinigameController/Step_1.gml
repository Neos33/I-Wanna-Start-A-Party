if (!started && get_player_count(player_check) == global.player_max) {
	fade_alpha -= 0.03 * DELTA;
	
	if (fade_alpha <= 0) {
		fade_alpha = 0;
		started = true;
		alarm_call(0, 1);
	}
}

if (finished) {
	fade_alpha += 0.03 * DELTA;
	
	if (fade_alpha >= 1) {
		fade_alpha = 1;
		finished = false;
		back_to_board();
	}
}

if (!IS_ONLINE && info.is_modes && announcer_started && !info.is_finished && global.actions.back.pressed()) {
	room_goto(rMinigameOverview);
}