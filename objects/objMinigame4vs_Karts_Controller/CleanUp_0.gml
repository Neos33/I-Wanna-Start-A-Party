event_inherited();
draw_set_alpha_test(false);
d3d_model_destroy(model_track);
d3d_model_destroy(model_grass);
d3d_model_destroy(model_player);
audio_stop_sound(sndMinigame4vs_Karts_PlayerEngineIdle);
audio_stop_sound(sndMinigame4vs_Karts_PlayerEngineLow);
audio_stop_sound(sndMinigame4vs_Karts_PlayerEngineHigh);
audio_stop_sound(sndMinigame4vs_Karts_PlayerDrift);
d3d_end();