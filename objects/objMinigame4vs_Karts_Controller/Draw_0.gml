var player = focus_player_by_turn(view_current + 1);

if (player.lookBehind) {
	x = player.x + (lengthdir_x(followDist, player.direction));
	y = player.y + (lengthdir_y(followDist, player.direction));
} else {
	x = player.x - (lengthdir_x(followDist, player.direction));
	y = player.y - (lengthdir_y(followDist, player.direction));
}
			
dir = point_direction(x, y, player.x, player.y);

var width = camera_get_view_width(view_camera[view_current]);
var height = camera_get_view_height(view_camera[view_current]);
d3d_set_projection_ortho(0, 0, width, height, 0);
var cdir = dir % 360;
draw_set_color(skyColor);
draw_rectangle(-1, -1, 961, 72, false);
draw_set_color(c_white);
draw_background_ext(sprBkgMinigame4vs_Karts_Clouds, (cdir * mv3 - 0), 0, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Clouds, (cdir * mv3 - 1600), 0, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Hills, (cdir * mv2 + 800), 25, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Hills, (cdir * mv2 - 0), 25, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Hills, (cdir * mv2 - 1000), 25, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Hills, (cdir * mv2 - 1800), 25, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Trees, (cdir * mv1 + 300), 41, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Trees, (cdir * mv1 - 0), 41, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Trees, (cdir * mv1 - 400), 41, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Trees, (cdir * mv1 - 850), 41, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Trees, (cdir * mv1 - 1200), 41, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Trees, (cdir * mv1 - 1700), 41, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Trees, (cdir * mv1 - 2000), 41, 2, 2, 0, c_white, 1);
draw_background_ext(sprBkgMinigame4vs_Karts_Trees, (cdir * mv1 - 2400), 41, 2, 2, 0, c_white, 1);
draw_set_color(c_white);
d3d_set_projection_ext(x, y, z, (x + (lengthdir_x(1.9, dir))), (y + (lengthdir_y(1.9, dir))), z - 1.5, 0, 0, 1, 90, width / height, 0.1, 2000);
texture_set_interpolation(false);
texture_set_repeat(true);
d3d_model_draw(model_grass, 0, 0, 0, tex_grass);
d3d_model_draw(model_track, 0, 0, 0, tex_track);
event_inherited();