delta = 1;
a = false;

timer = time_source_create(time_source_game, 1, time_source_units_seconds, function() {
	global.ellapsed_time += global.game_started;
}, [], -1);

time_source_start(timer);