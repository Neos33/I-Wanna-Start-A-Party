var focus = focus_player();
var c = instance_create_layer(focus.x, focus.y, "Actors", objCoin);
c.vspeed = -8;

if (++animation_amount == abs(amount)) {
	alarm[11] = 30;
	exit;
}

alarm[2] = game_get_speed(gamespeed_fps) * 0.15;