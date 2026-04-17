spawn_timer--;

if (spawn_timer <= 0) {
    spawn_timer = irandom_range(spawn_rate * 0.5, spawn_rate * 1.5);

    // 1. Đếm xem Spawner này đang quản lý bao nhiêu con quái còn sống
    var _my_current_enemies = 0;
    with (obj_enemy) {
        // Chỉ đếm những con có lưu ID của spawner này
        if (variable_instance_exists(id, "spawner_owner") && spawner_owner == other.id) {
            _my_current_enemies++;
        }
    }

    // 2. Nếu quái CỦA MÌNH chưa đạt max thì mới đẻ
    if (_my_current_enemies < max_enemies) {

        var _spawn_x, _spawn_y;
        var _is_safe = false;
        var _attempts = 0;

        while (!_is_safe && _attempts < 10) {
            var _dir = random(360);
            var _dist = random(spawn_radius);

            _spawn_x = x + lengthdir_x(_dist, _dir);
            _spawn_y = y + lengthdir_y(_dist, _dir);

            _is_safe = true;

            // Không spawn trong tường
            if (tilemap_get_at_pixel(tilemap_id, _spawn_x, _spawn_y) != 0) _is_safe = false;

            // Không spawn gần player
            if (instance_exists(obj_player)) {
                if (point_distance(_spawn_x, _spawn_y, obj_player.x, obj_player.y) < 300) _is_safe = false;
            }

            // Không spawn trong tầm nhìn (Nếu hàm này đã cover được thì giữ)
            if (can_player_see(_spawn_x, _spawn_y)) _is_safe = false;

            _attempts++;
        }

        if (_is_safe) {
            var _rand_index = irandom(array_length(enemy_list) - 1);
            var _chosen_enemy = enemy_list[_rand_index];

            // 3. Tạo quái và gán ID của Spawner vào con quái đó
            var _inst = instance_create_layer(_spawn_x, _spawn_y, "Instances_Enemies", _chosen_enemy);
            _inst.spawner_owner = id; 
        }
    }
}