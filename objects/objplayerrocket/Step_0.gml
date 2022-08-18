if (!frozen) {
	image_angle = (image_angle + 360 + (global.actions.left.held(network_id) - global.actions.right.held(network_id))) % 360;
	var move = (global.actions.up.held(network_id) - global.actions.down.held(network_id));
	
	if (move != 0) {
		motion_add(image_angle + 90, move * 0.05);
	}

	speed = clamp(speed, -max_spd, max_spd);
	spd = speed;
	
	if (shoot_delay == 0 && global.actions.shoot.pressed(network_id)) {
		shoot_delay = get_frames(1);
		player_shoot(10, image_angle + 90);
	}
	
	shoot_delay = max(--shoot_delay, 0);
} else {
    hspeed = 0;
    vspeed = 0;
}

if (place_meeting(x + hspeed, y, objBlock)) {
	hspeed *= -0.8;
}

if (place_meeting(x, y + vspeed, objBlock)) {
	vspeed *= -0.8;
}