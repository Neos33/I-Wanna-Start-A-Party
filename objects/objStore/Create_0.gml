fade_alpha = 1;
fade_start = true;
back = false;
surf = noone;
timer = 0;
dir = 1;

function Stock(index, price, has, buy, item, info) constructor {
	self.index = index;
	self.price = price;
	self.has = method(self, has);
	self.buy = method(self, buy);
	self.item = method(self, item);
	self.info = method(self, info);
}

store_stock = [[], [], [], []];

for (var i = 0; i < array_length(global.boards); i++) {
	array_push(store_stock[0], new Stock(i, global.board_price, function() {
		return board_collected(self.index);
	}, function() {
		change_collected_coins(-self.price);
		board_collect(self.index);
	}, function(x, y, _) {
		var logo = (self.has()) ? self.index + 1 : 0;
		draw_sprite_ext(sprPartyBoardLogos, logo, x, y, 0.4, 0.4, 0, c_white, objStore.store_alpha);
	}, function(x, y) {
		var board = global.boards[self.index];
		var name = (self.has()) ? board.name : "?????????";
		var picture = (self.has()) ? self.index + 1 : 0;
		draw_sprite_stretched(sprFangameMark, 1, x + 72, 60, 200, 152);
		gpu_set_colorwriteenable(true, true, true, false);
		draw_sprite_stretched(sprPartyBoardPictures, picture, x + 72, 60, 200, 152);
		gpu_set_colorwriteenable(true, true, true, true);
		draw_sprite_stretched(sprFangameMark, 0, x + 72, 60, 200, 152);
		draw_set_font(fntFilesButtons);
		draw_set_halign(fa_center);
		draw_text_color_outline(x + objStore.draw_w / 2, 10, name, c_red, c_red, c_fuchsia, c_fuchsia, 1, c_black);
		draw_set_font(fntFilesData);
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_text_outline(x + 20, 230, "Maker(s): " + board.makers, c_black);
	}));
}

var types = minigame_types();

for (var i = 0; i < array_length(types); i++) {
	var minigames = global.minigames[$ types[i]];
	
	for (var j = 0; j < array_length(minigames); j++) {
		var minigame = minigames[j];
		
		var stock = new Stock(, global.minigame_price, function() {
			return minigame_seen(self.minigame.title);
		}, function() {
			change_collected_coins(-self.price);
			minigame_unlock(self.minigame.title);
		}, function(x, y, _) {
			var seen_minigame = self.has();
			var title = (seen_minigame) ? self.minigame.title : "?????????";
			var portrait = (seen_minigame) ? self.minigame.portrait : self.minigame.hidden;
			draw_set_font(fntPlayerInfo);
			draw_set_halign(fa_center);
			draw_sprite_ext(portrait, 0, x, y - 30, 0.5, 0.5, 0, c_white, objStore.store_alpha);
			draw_set_halign(fa_left);
		}, function(x, y) {
			var seen_minigame = self.has();
			var title = (seen_minigame) ? self.minigame.title : "?????????";
			var preview = (seen_minigame) ? self.minigame.preview : 0;
			var fangame_name = (seen_minigame) ? self.minigame.fangame_name : "???";
			draw_sprite_stretched(sprFangameMark, 1, x + 72, 60, 200, 152);
			gpu_set_colorwriteenable(true, true, true, false);
			draw_sprite_stretched(sprMinigamesFangames, preview, x + 72, 60, 200, 152);
			gpu_set_colorwriteenable(true, true, true, true);
			draw_sprite_stretched(sprFangameMark, 0, x + 72, 60, 200, 152);
			draw_set_font(fntFilesButtons);
			draw_set_halign(fa_center);
			draw_text_color_outline(x + objStore.draw_w / 2, 10, title, c_red, c_red, c_fuchsia, c_fuchsia, 1, c_black);
			draw_set_font(fntFilesData);
			draw_set_color(c_white);
			draw_text_outline(x + objStore.draw_w / 2, 220, fangame_name, c_black);
		});
		
		stock.minigame = minigame;
		array_push(store_stock[1], stock);
	}
}

for (var i = 0; i < array_length(global.skins); i++) {
	var skin = global.skins[i];
	array_push(store_stock[2], new Stock(i, skin.price, function() {
		return have_skin(self.index);	
	}, function() {
		change_collected_coins(-self.price);
		gain_skin(self.index);
	}, function(x, y, moving) {
		var skin = get_skin(self.index);
		var sprite = skin[$ ((moving) ? "Idle" : "Run")];
		draw_sprite_ext(sprite, objStore.timer * sprite_get_speed(sprite) / game_get_speed(gamespeed_fps), x, y, 2 * objStore.dir, 2, 0, c_white, objStore.store_alpha);
	}, function(x, y) {
		var skin = global.skins[self.index];
		draw_sprite_stretched(sprFangameMark, 1, x + 72, 60, 200, 152);
		gpu_set_colorwriteenable(true, true, true, false);
		draw_sprite_stretched(sprSkinsFangames, skin.fangame_index, x + 72, 60, 200, 152);
		gpu_set_colorwriteenable(true, true, true, true);
		draw_sprite_stretched(sprFangameMark, 0, x + 72, 60, 200, 152);
		draw_set_font(fntFilesButtons);
		draw_set_halign(fa_center);
		draw_text_color_outline(x + objStore.draw_w / 2, 10, skin.name, c_red, c_red, c_fuchsia, c_fuchsia, 1, c_black);
		draw_set_font(fntFilesData);
		draw_set_color(c_white);
		draw_text_outline(x + objStore.draw_w / 2, 220, skin.fangame_name, c_black);
		draw_set_halign(fa_left);
		draw_text_outline(x + 20, 260, "Maker: " + skin.maker, c_black);
	}));
}

for (var i = 0; i < array_length(global.reactions); i++) {
	var react = global.reactions[i];
	array_push(store_stock[3], new Stock(i, react.price, function() {
		return have_reaction(self.index);	
	}, function() {
		change_collected_coins(-self.price);
		gain_reaction(self.index);
	}, function(x, y, _) {
		draw_sprite_ext(sprReactions, self.index, x, y - 10, 0.25, 0.25, 0, c_white, objStore.store_alpha);
	}, function(x, y) {
		var react = global.reactions[self.index];
		draw_sprite_ext(sprReactions, react.index, x + objStore.draw_w / 2, 160, 0.75, 0.75, 0, c_white, 1);
		draw_set_font(fntFilesButtons);
		draw_set_halign(fa_center);
		draw_text_color_outline(x + objStore.draw_w / 2, 10, react.name, c_red, c_red, c_fuchsia, c_fuchsia, 1, c_black);
		draw_set_font(fntFilesData);
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_text_outline(x + 20, 260, "Maker: " + react.maker, c_black);
	}));
}

store_alpha = 1;
store_target_alpha = store_alpha;
store_row = 0;
store_move_row = 0;
store_selected = array_create(array_length(store_stock), 0);
store_target_selected = array_create(array_length(store_stock), 0);
store_x = 400;
store_target_x = 400;

held_time = 0;
controls_text = new Text(fntDialogue);

draw_x = 224;
draw_y = 32;
draw_w = 32 * 11;
draw_h = 32 * 13 - 112;