part_system_clear(part_sys);
part_type_destroy_safe(part_cloud_type);
part_type_destroy_safe(part_cloud_type2);
part_type_destroy_safe(part_leaf_type);
part_emitter_destroy_safe(part_sys, part_cloud_emitter);
part_emitter_destroy_safe(part_sys, part_cloud_emitter2);
part_emitter_destroy_safe(part_sys, part_leaf_emitter);
part_system_destroy_safe(part_sys);