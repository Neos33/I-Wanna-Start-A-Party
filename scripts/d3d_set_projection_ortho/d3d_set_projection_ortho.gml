/// @description d3d - set orthographic 
/// @param x		x of tl corner
/// @param y		y of tl corner
/// @param w		w of view
/// @param h		h of view
/// @param angle	rotation angle of the projection
function d3d_set_projection_ortho(argument0, argument1, argument2, argument3, argument4) {

	var xx = argument0;
	var yy = argument1;
	var ww = argument2;
	var hh = argument3;
	var angle = argument4;

	var mV = matrix_build_lookat( xx+ww/2, yy+hh/2, -16000, 
								  xx+ww/2, yy+hh/2, 0,
								 dsin(-angle), dcos(-angle), 0 );
	var mP = matrix_build_projection_ortho( ww, hh, 1, 32000 );

	//camera_set_view_mat( global.__d3dCamera, mV );
	//camera_set_proj_mat( global.__d3dCamera, mP );
	//camera_apply( global.__d3dCamera );
	camera_set_view_mat( view_camera[view_current], mV );
	camera_set_proj_mat( view_camera[view_current], mP );
	camera_apply( view_camera[view_current] );


}
