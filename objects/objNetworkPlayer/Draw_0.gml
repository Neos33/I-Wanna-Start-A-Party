if (sprite_index != -1 && sprite_index != sprPlayer && room == network_room) {
	draw_sprite_ext(sprite_index, image_index, x, y - ((IS_BOARD) ? 5 : 0), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}