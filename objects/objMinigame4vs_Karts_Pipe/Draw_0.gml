var cdir = objMinigameController.dir - 90;
var cdirtan = 90;
d3d_transform_set_translation(0, -0.5, 0);
d3d_transform_add_scaling(8, 8, 8);
d3d_transform_add_rotation_x(cdirtan);
d3d_transform_add_rotation_z(cdir);
d3d_transform_add_translation(x, y, z);
d3d_model_draw(objMinigameController.model_pipe, 0, 0, 0, objMinigameController.tex_pipe);
d3d_transform_set_identity();