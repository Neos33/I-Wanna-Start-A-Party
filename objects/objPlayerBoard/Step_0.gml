if (is_local_turn() && can_jump && global.actions.jump.pressed(network_id)) {
	vspeed = -6;
	gravity = 0.4;
	dice_hit_y = y;
	can_jump = false;
	audio_play_sound(sndJump, 0, false);
}