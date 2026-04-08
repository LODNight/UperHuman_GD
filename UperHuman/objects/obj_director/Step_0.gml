spawn_timer--;

// Noise decay
global.noise_level = max(0, global.noise_level - 0.01);

// Nếu ồn → spawn nhanh hơn
var _noise_bonus = clamp(global.noise_level, 0, 10);

spawn_rate = 120 - (_noise_bonus * 5);
spawn_rate = max(30, spawn_rate);

if (spawn_timer <= 0) {

    // random thời gian spawn
    spawn_timer = irandom_range(spawn_rate * 0.7, spawn_rate * 1.5);

    if (instance_number(obj_enemy) >= max_enemies) exit;

    if (!instance_exists(obj_player)) exit;

    var _spawn_x, _spawn_y;
    var _found = false;
    var _tries = 0;

    while (!_found && _tries < 20) {

        // 🔥 spawn quanh player (KHÔNG phải spawner)
        var _dir = random(360);
        var _dist = random_range(spawn_min_dist, spawn_max_dist);

        _spawn_x = obj_player.x + lengthdir_x(_dist, _dir);
        _spawn_y = obj_player.y + lengthdir_y(_dist, _dir);

        _found = true;

		
        // ❌ trong tường
        if (tilemap_get_at_pixel(tilemap_id, _spawn_x, _spawn_y) != 0)
            _found = false;

        // ❌ trong màn hình (camera)
        if (point_in_rectangle(_spawn_x, _spawn_y,
            camera_get_view_x(view_camera[0]),
            camera_get_view_y(view_camera[0]),
            camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]),
            camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0])
        )) {
            _found = false;
        }

        // ❌ trong tầm nhìn player (LOS)
        if (!check_los_tilemap(obj_player.x, obj_player.y, _spawn_x, _spawn_y)) {
            _found = false;
        }

        _tries++;
    }

    if (_found) {

        var _rand = irandom(array_length(enemy_list) - 1);
        var _enemy = enemy_list[_rand];
		
		var _spawn_count = 1;

		if (global.noise_level > 5) {
		    _spawn_count = irandom_range(2, 4);
		}

		for (var i = 0; i < _spawn_count; i++) {
		    instance_create_layer(_spawn_x, _spawn_y, "Instances_Enemies", _enemy);
		}

        instance_create_layer(_spawn_x, _spawn_y, "Instances_Enemies", _enemy);
    }
}

if (instance_exists(obj_player)) {
    if (point_distance(x, y, obj_player.x, obj_player.y) > 1000) {
        instance_destroy();
    }
}