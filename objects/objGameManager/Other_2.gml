sprite_prefetch_multi([
	sprBkgTitle,
	sprMinigamesFangames,
	sprSkinsFangames,
	sprTrophyImages,
	sprMinigameOverview_Pictures
]);

audio_group_load(audiogroup_BGM);
audio_group_load(audiogroup_SFX);
//music_loop_init();

if (file_exists("update.bat")) {
	file_delete("update.bat");
}

for (var i = 0; i < 3; i++) {
	save_variables();
	global.file_selected = i;
	
	if (!load_file()) {
		save_file();
	}
}

global.file_selected = -1;

languages_init();
language_fonts_init();
config_variables();

if (!load_config()) {
	save_config();
}

apply_config();

board_init();
minigame_init();
minigame_info_reset();
items_init();
results_init();
trial_init();
trial_info_reset();
skin_init();
reaction_init();
trophies_init();

controls_text = new Text(global.fntControls);