spawn_timer--;

if (spawn_timer <= 0) {
    spawn_timer = spawn_rate;
    
    // Đếm tổng số lượng tất cả các loại quái đang sống (dựa vào Object Cha)
    if (instance_number(obj_enemy) < max_enemies) {
        
        var _spawn_x = x;
        var _spawn_y = y;
        var _is_safe = false;
        var _attempts = 0; 
        
        while (!_is_safe && _attempts < 10) {
            var _dir = random(360);
            var _dist = random(spawn_radius);
            _spawn_x = x + lengthdir_x(_dist, _dir);
            _spawn_y = y + lengthdir_y(_dist, _dir);
            
            if (tilemap_get_at_pixel(tilemap_id, _spawn_x, _spawn_y) == 0) {
                _is_safe = true;
            }
            _attempts++;
        }
        
        if (_is_safe) {
            // --- KHÚC QUAN TRỌNG: CHỌN QUÁI NGẪU NHIÊN ---
            // Chọn một vị trí ngẫu nhiên từ 0 đến (chiều dài mảng - 1)
            var _rand_index = irandom(array_length(enemy_list) - 1);
            var _chosen_enemy = enemy_list[_rand_index];
            
            // Tiến hành đẻ con quái đã chọn
            instance_create_layer(_spawn_x, _spawn_y, "Instances_Enemies", _chosen_enemy);
        }
    }
}