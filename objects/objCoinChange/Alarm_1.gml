///@desc Coin Gain Animation
var focus = focused_player_turn();
var c = instance_create_layer(focus.x, focus.y - 69, "Actors", objCoin);
c.vspeed = 6;

if (++animation_amount == amount) {
	alarm[11] = 20;
	exit;
}

alarm[1] = game_get_speed(gamespeed_fps) * 0.15;