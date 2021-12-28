if (instance_exists(objItemChange) || instance_exists(objThingChange)) {
	exit;
}

draw_set_font(fntDice);
draw_set_alpha(1);
draw_set_color(make_color_rgb(244, 233, 0));
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var focus = focused_player_turn();
draw_text_outline((follow_x) ? focus.x : x, (follow_y) ? focus.y - 53 : y, (roll == 0) ? string(global.dice_roll) : roll, c_black);
draw_set_valign(fa_top);
draw_set_halign(fa_left);