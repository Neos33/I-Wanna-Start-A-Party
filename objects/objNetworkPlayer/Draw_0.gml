if (room == network_room) {
	draw_sprite_ext(network_sprite, network_subimg, network_x, network_y, network_xscale, network_yscale, 0, c_white, network_alpha);
	draw_set_color(c_black);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(network_x + 16, network_y + 16, string(network_id));
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
}