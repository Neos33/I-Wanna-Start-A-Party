event_inherited();

function init_view() {
	view_w = camera_get_view_width(view_camera[camera]);
	view_h = camera_get_view_height(view_camera[camera]);
	view_w_half = floor(view_w / 2);
	view_h_half = floor(view_h / 2);
	
	for (var i = 0; i < global.player_max; i++) {
		view_x[i] -= view_w_half;
		view_y[i] -= view_h_half;
		target_x[i] = view_x[i];
		target_y[i] = view_y[i];
	}
}

boundaries = false;
draw_names = true;

switch (room) {
	case rMinigame4vs_Tower:
		var w = 200;
		var h = 608;
		mode = 1;
		break;
		
	case rMinigame4vs_Jingle:
	case rMinigame4vs_Leap:
		var w = 800;
		var h = 152;
		mode = 2;
		break;
		
	case rMinigame1vs3_Race:
		var w = 800;
		var h = 304;
		mode = 2;
		draw_names = false;
		break;
		
	case rMinigame2vs2_Duos:
		var w = 800;
		var h = 152;
		mode = 2;
		break;
	
	default:
		var w = 400;
		var h = 304;
		mode = 0;
		break;
}

for (var i = 0; i < global.player_max; i++) {
	target_follow[i] = null;
	view_x[i] = 0;
	view_y[i] = 0;
	target_x[i] = 0;
	target_y[i] = 0;
	view_visible[i] = true;
	var camera = view_camera[i];

	switch (room) {
		case rMinigame4vs_Crates:
			view_wport[i] = w;
			view_hport[i] = h;
			camera_set_view_size(camera, w / 2, h / 2);
			break;
			
		case rMinigame4vs_Karts:
			view_wport[i] = w * 2;
			view_hport[i] = h * 2;
			camera_set_view_size(camera, w * 2, h * 2);
			break;
			
		default:
			view_wport[i] = w;
			view_hport[i] = h;
			camera_set_view_size(camera, w, h);
			break;
	}
}

view_surfs = array_create(global.player_max, noone);
application_surface_draw_enable(false);
dead = array_create(global.player_max, false);
lock_x = false;
lock_y = false;