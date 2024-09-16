with (instance_place(x, y - 1, objPlayerBase)) {
	if (!is_player_local(network_id) || coin_following) {
		break;
	}
	
	if (global.actions.shoot.pressed(network_id)) {
		with (other) {
			coin_follow(other.network_id);
		}
		
		coin_following = true;
	}
}

if (following_id != null) {
	if (global.actions.shoot.released(following_id) || objMinigameController.info.is_finished) {
		with (focus_player_by_id(following_id)) {
			coin_following = false;
		}
		
		coin_unfollow();
	}
}