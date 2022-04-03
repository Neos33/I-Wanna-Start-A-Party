info = global.minigame_info;
state = 0;
alpha = 1;
places_minigame_repeated = [];
places_minigame_info = [];
places_minigame_order = [];

function minigame_info_placement() {
	places_minigame_repeated = array_create(global.player_max, 0);
	places_minigame_info = [];
	places_minigame_order = [];
		
	for (var i = 1; i <= global.player_max; i++) {
		var info = player_info_by_turn(i);
		var order = info.place + places_minigame_repeated[info.place - 1];
		places_minigame_repeated[info.place - 1]++;
		
		with (objPlayerInfo) {
			if (player_info.turn == i) {
				array_push(other.places_minigame_info, id);
				array_push(other.places_minigame_order, order);
			}
		}
	}
}

minigame_info_placement();

for (var i = 0; i < global.player_max; i++) {
	var player_info = places_minigame_info[i];
	var order = places_minigame_order[i];
	var player = focus_player_by_id(player_info.player_info.network_id);
	player.x = (400 - player_info.draw_w / 2) + 15 + camera_get_view_x(view_camera[0]);
	player.y = (79 + (player_info.draw_h + 30) * (order - 1)) - 20 + camera_get_view_y(view_camera[0]);
}