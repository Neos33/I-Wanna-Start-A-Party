if (keyboard_check_pressed(ord("J"))) {
	instance_create_layer(0, 0, "Managers", objNetworkClient);
}

if (keyboard_check_pressed(vk_pagedown)) {
	room_goto_next();
}

if (keyboard_check_pressed(vk_pageup)) {
	room_goto_previous();
}

if (keyboard_check_pressed(vk_f2)) {
	game_restart();
}