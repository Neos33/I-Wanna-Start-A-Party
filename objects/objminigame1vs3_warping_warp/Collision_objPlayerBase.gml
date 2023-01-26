var solo_player = minigame1vs3_solo();

if (!is_player_local(other.network_id) || other.network_id != solo_player.network_id) {
	exit;
}

var player = other;

if (image_index == 0) {
	with (object_index) {
		if (image_index == 1) {
			player.x = x + 17;
			player.y = y + 23;
			audio_play_sound(sndMinigame1vs3_Warping_Warp, 0, false);
			break;
		}
	}
}

if (solo_player.network_id == global.player_id && vspeed != 0) {
	objMinigameController.trophy_warp = false;
}