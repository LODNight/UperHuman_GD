spawn_timer--;

if (spawn_timer <= 0) {

    spawn_timer = irandom_range(spawn_rate * 0.5, spawn_rate * 1.5);

    if (instance_number(obj_enemy) < max_enemies) {

        var _spawn_x, _spawn_y;
        var _is_safe = false;
        var _attempts = 0;

        while (!_is_safe && _attempts < 10) {

            var _dir = random(360);
            var _dist = random(spawn_radius);

            _spawn_x = x + lengthdir_x(_dist, _dir);
            _spawn_y = y + lengthdir_y(_dist, _dir);

            _is_safe = true;

            // ❌ Không spawn trong tường
            if (tilemap_get_at_pixel(tilemap_id, _spawn_x, _spawn_y) != 0)
                _is_safe = false;

            // ❌ Không spawn gần player
            if (instance_exists(obj_player)) {
                if (point_distance(_spawn_x, _spawn_y, obj_player.x, obj_player.y) < 300)
                    _is_safe = false;
            }

            // ❌ Không spawn trong tầm nhìn
            if (can_player_see(_spawn_x, _spawn_y))
                _is_safe = false;

            _attempts++;
        }

        if (_is_safe) {
            var _rand_index = irandom(array_length(enemy_list) - 1);
            var _chosen_enemy = enemy_list[_rand_index];

            instance_create_layer(_spawn_x, _spawn_y, "Instances_Enemies", _chosen_enemy);
        }
    }
}