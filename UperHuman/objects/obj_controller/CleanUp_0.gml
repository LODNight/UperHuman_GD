lighting_cleanup();

// Dọn dẹp ds_list cho Horde System
if (ds_exists(global.shared_enemy_list, ds_type_list)) {
    ds_list_destroy(global.shared_enemy_list);
}