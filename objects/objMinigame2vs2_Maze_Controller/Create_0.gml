with (objPlayerBase) {
	change_to_object(objPlayerPlatformer);
}

with (objPlayerBase) {
	grav_amount = 0;
	enable_shoot = false;
	has_item = false;
	jump_total = -1;
}

event_inherited();

minigame_start = minigame2vs2_start;
minigame_camera = CameraMode.Split4;
player_check = objPlayerPlatformer;
distance_to_win = 16;
