LIVE

if (info.is_practice || (global.trial_info.reference != null && global.trial_info.current == 1)) {
	draw_set_font(fntPopup);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	if (global.trial_info.reference == null) {
		var text = "Press       to exit practice";
	} else {
		var text = "Press       to restart trial";
	}
	
	draw_text_color_outline(display_get_gui_width() / 2, display_get_gui_height() / 2, text, c_orange, c_orange, c_yellow, c_yellow, practice_alpha, c_black);
	draw_sprite_ext(global.actions.misc.bind(), 0, display_get_gui_width() / 2 - 95, display_get_gui_height() / 2, 1, 1, 0, c_white, practice_alpha);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
}

if (minigame_time != -1) {
	var w = 100;
	var h = 32;
	
	switch (minigame_time_halign) {
		case fa_left: var xx = 0; break;
		case fa_center: var xx = display_get_gui_width() / 2 - w / 2; break;
		case fa_right: var xx = display_get_gui_width() - w; break;
	}
	
	switch (minigame_time_valign) {
		case fa_top: var yy = h; break;
		case fa_middle: var yy = display_get_gui_height() / 2 + h / 2; break;
		case fa_bottom: var yy = display_get_gui_height(); break;
	}
	
	draw_box(xx, yy - h, w, h, c_dkgray, c_white);
	draw_set_font(fntDialogue);
	
	if (minigame_time > 5) {
		draw_set_color(c_yellow);
	} else {
		draw_set_color(c_red);
	}
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_outline(xx + w / 2, yy - h / 2 + 2, string(minigame_time), c_black);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
}

if (points_draw) {
	var is_4vs = (array_length(points_teams) == 4);
	
	for (var i = 0; i < array_length(points_teams); i++) {
		if (is_4vs) {
			var xx = 170 + 120 * i;
		} else {
			var xx = 245 + 180 * i;
		}
		
		var yy = 0;
		draw_box(xx, yy, (is_4vs) ? 100 : 130, 32, (is_4vs) ? player_color_by_turn(i + 1) : info.player_colors[i], c_white);
		draw_set_font(fntDialogue);
	
		var team = points_teams[i];
		var points = 0;
	
		for (var j = 0; j < array_length(team); j++) {
			var player = team[j];
			points += info.player_scores[player.network_id - 1].points;
			draw_sprite(focus_info_by_id(player.network_id).player_idle_image, 0, xx + ((is_4vs) ? 75 : 105) - 20 * j, yy + 19);
		}
	
		draw_set_color(c_white);
		
		if (points_number) {
			draw_text_outline(xx + 15, yy + 5, string(points), c_black);
		}
	}
}