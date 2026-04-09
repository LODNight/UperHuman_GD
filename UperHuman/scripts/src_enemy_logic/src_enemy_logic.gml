
/// @function enemy_state_idle():
function enemy_state_idle() {
    // Thỉnh thoảng quay đầu ngẫu nhiên ngó nghiêng
    if (irandom(100) > 98) {
        direction += random_range(-45, 45);
    }
    
   if (investigate_timer > 0) {
	    investigate_timer--;
	    direction += random_range(-3, 3);
	    return;
	}

	// Sau khi hết investigate mới check player
	if (enemy_check_vision()) {
	    state = ENEMY_STATE.WALK;
	}
}

/// @description Nghe tiếng động, đi tới chỗ phát ra tiếng ồn để kiểm tra
function enemy_state_investigate() {

    // Nếu thấy player → chuyển qua chase ngay
    if (enemy_check_vision()) {
        path_end();
        state = ENEMY_STATE.WALK;
        return;
    }

    // =========================
    // PATH ĐẾN ĐIỂM NGHI NGỜ
    // =========================
    if (path_timer-- <= 0) {
        path_timer = 10;

        if (mp_grid_path(global.grid, path, x, y, target_x, target_y, true)) {
            path_start(path, move_spd * 0.8, path_action_stop, false);
        }
    }

    // =========================
    // QUAY MẶT THEO DI CHUYỂN
    // =========================
    if (path_position > 0) {

        var _dir = point_direction(x, y, target_x, target_y);
		direction = lerp(direction, _dir, 0.15);
    }

    // =========================
    // ĐẾN NƠI → CHECK XUNG QUANH
    // =========================
    var _dist = point_distance(x, y, target_x, target_y);

    if (_dist < 12) {

        path_end();

        // đứng check 1 chút cho real
        investigate_timer = 30;
        state = ENEMY_STATE.IDLE;
    }
}

/// @description Trạng thái di chuyển theo đối tượng
function enemy_state_walk() {

    if (!instance_exists(obj_player)) {
        path_end();
        state = ENEMY_STATE.IDLE;
        return;
    }

    var _dist = point_distance(x, y, obj_player.x, obj_player.y);

    // =========================
    // PATH (xa thì dùng path)
    // =========================
    if (_dist > 150) {

        if (path_timer-- <= 0) {
            path_timer = 20;

            if (mp_grid_path(global.grid, path, x, y, obj_player.x, obj_player.y, true)) {
                path_start(path, move_spd, path_action_stop, false);
            }
        }
    }
    else {
        // =========================
        // STEERING REAL
        // =========================
        path_end();

		var _vel = enemy_calculate_velocity();

		// move thật
		var _real_vel = enemy_move_with_collision(_vel[0], _vel[1]);

		// CHỈ QUAY THEO REAL VEL (KHÔNG DÙNG _vel NỮA)
		if (_real_vel[0] != 0 || _real_vel[1] != 0) {
		    var _move_dir = point_direction(0, 0, _real_vel[0], _real_vel[1]);

		    direction = lerp(direction, _move_dir, 0.2);
		    direction += random_range(-2, 2);
		}
    }

    // =========================
    // ATTACK
    // =========================
    if (_dist <= attack_range && attack_timer <= 0) {
        state = ENEMY_STATE.ATTACK;
        image_index = 0;
        has_dealt_damage = false;
        return;
    }

    // =========================
    // LOSE TARGET
    // =========================
    if (_dist > chase_range) {
        state = ENEMY_STATE.IDLE;
        return;
    }

    // =========================
    // HORDE SIGNAL
    // =========================
    aggro_active = true;
    aggro_timer = 300;

    aggro_target_x = obj_player.x;
    aggro_target_y = obj_player.y;

    with (obj_enemy) {
        if (point_distance(x, y, other.x, other.y) < 200) {
            aggro_active = true;
            aggro_target_x = other.aggro_target_x;
            aggro_target_y = other.aggro_target_y;
        }
    }
}

/// @description Áp dụng hiệu ứng đẩy lùi
function enemy_apply_knockback() {
    if (knockback_spd > 0) {
        // 1. Tính toán khoảng cách bị văng
        var _hspd = lengthdir_x(knockback_spd, knockback_dir);
        var _vspd = lengthdir_y(knockback_spd, knockback_dir);
        
        // 2. Lấy dữ liệu của bức tường (Tilemap)
        var _lay_id = layer_get_id("Tiles_Collision");
        var _map_id = layer_tilemap_get_id(_lay_id);

        // 3. XỬ LÝ VĂNG NGANG: Check xem nếu văng thêm _hspd thì có đụng gạch không?
        // (Kiểm tra cả mép trên và mép dưới của quái vật để không bị kẹt góc)
        var _bbox_side_x;
        if (_hspd > 0) _bbox_side_x = bbox_right; else _bbox_side_x = bbox_left;
        
        if (tilemap_get_at_pixel(_map_id, _bbox_side_x + _hspd, bbox_top) > 0 || 
            tilemap_get_at_pixel(_map_id, _bbox_side_x + _hspd, bbox_bottom) > 0) {
            _hspd = 0; // Đụng tường -> Dừng lực văng ngang ngay lập tức
        }
        x += _hspd; // Áp dụng di chuyển ngang an toàn

        // 4. XỬ LÝ VĂNG DỌC: Check xem nếu văng thêm _vspd thì có đụng gạch không?
        // (Kiểm tra cả mép trái và mép phải)
        var _bbox_side_y;
        if (_vspd > 0) _bbox_side_y = bbox_bottom; else _bbox_side_y = bbox_top;
        
        if (tilemap_get_at_pixel(_map_id, bbox_left, _bbox_side_y + _vspd) > 0 || 
            tilemap_get_at_pixel(_map_id, bbox_right, _bbox_side_y + _vspd) > 0) {
            _vspd = 0; // Đụng tường -> Dừng lực văng dọc ngay lập tức
        }
        y += _vspd; // Áp dụng di chuyển dọc an toàn

        // 5. Giảm ma sát để quái dừng lại từ từ
        knockback_spd = lerp(knockback_spd, 0, 0.1);
        if (knockback_spd < 0.5) knockback_spd = 0;
    }
}

/// @description Trạng thái bị tấn công
function enemy_state_hit() {
    path_end();
    //enemy_apply_knockback();
    
    hit_timer--;
    if (hit_timer <= 0) {
        // Ép xoay mặt về phía kẻ thù vừa bắn mình
        if (instance_exists(obj_player)) {
            direction = point_direction(x, y, obj_player.x, obj_player.y);
        }
        
        // Mặc định cho nó đi điều tra, nhưng vì nó vừa bị xoay mặt nhìn trúng Player 
        // nên mắt nó sẽ quét trúng và chuyển sang RƯỢT ngay lập tức
        state = ENEMY_STATE.INVESTIGATE; 
    }
}

/// @description Trạng thái tấn công
function enemy_state_attack() {
    
	if (image_index >= image_number - 1) {
	    // SAU KHI ĐÁNH XONG: Ép nó quay về trạng thái đi bộ
	    state = ENEMY_STATE.WALK
	    // Đặt lại thời gian hồi chiêu (ví dụ 60 frame = 1 giây sau mới được cắn tiếp)
	    attack_timer = 60; 
	}
}

/// @description Trạng thái tấn công
function enemy_state_dead() {
    instance_destroy();
}

/// @description Xử lý hành vi theo từng trạng thái
function enemy_update_sprite() {
    // Xác định hướng 4 chiều (0: Phải, 1: Dưới, 2: Trái, 3: Trên)
    var dir4 = round(direction / 90) mod 4;
    dir4 = (4 - dir4) mod 4;

    var spr_array;

    // Chọn mảng sprite theo trạng thái
    if (state == ENEMY_STATE.HIT) {
        spr_array = spr_hit;
    } else if (state == ENEMY_STATE.ATTACK) {
		spr_array = spr_attack;	
	} else {
        spr_array = spr_walk;
    }

    // Lấy sprite thực tế từ mảng
    var new_sprite = spr_array[dir4];

    // Chỉ đổi khi cần để animation không bị reset liên tục
    if (sprite_index != new_sprite && new_sprite != noone) {
        sprite_index = new_sprite;
        image_index = 0;
    }
}

/// @description Cập nhật hình ảnh sprite theo hướng di chuyển
function enemy_update_sprite_direction() {
    // Ép hình ảnh luôn xoay theo hướng nhìn hiện tại (Bỏ cái if check speed đi)
    image_angle = direction;
}

/// @description Hệ thống tầm nhìn cho Enemy
function enemy_visible(){
	if (instance_exists(obj_player)) {
	    // 1. Khai báo thông số mắt nhìn của Player
	    var _view_distance = 400; // Nhìn xa tối đa 400 pixel
	    var _fov = 100;           // Góc nhìn rộng 100 độ (Mỗi bên 50 độ)
    
	    // 2. Tính khoảng cách và hướng từ Player tới con quái này
	    var _dist_to_player = point_distance(obj_player.x, obj_player.y, x, y);
	    var _dir_to_enemy = point_direction(obj_player.x, obj_player.y, x, y);
    
	    // 3. Tính độ lệch góc (Góc nhìn của Player so với vị trí của quái)
	    var _angle_diff = abs(angle_difference(obj_player.image_angle, _dir_to_enemy));
    
	    // 4. QUYẾT ĐỊNH HIỂN THỊ
	    // Nếu quái nằm trong tầm xa VÀ góc lệch nhỏ hơn một nửa FOV
	    if (_dist_to_player <= _view_distance && _angle_diff <= (_fov / 2)) {
	        visible = true;  // Nằm trong tầm mắt -> Hiện hình
	    } else {
	        visible = false; // Khuất tầm mắt -> Tàng hình
	    }
    
	    // 5. GIÁC QUAN THỨ 6 (Ngoại lệ Zomboid)
	    // Nếu quái áp sát quá gần (ví dụ 60 pixel), tự động thấy dù ở sau lưng
	    if (_dist_to_player <= 60) {
	        visible = true; 
	    }
	}	
	
}

/// @description Bắn tia laser để xem có bị chặn bởi Tilemap tường không
function check_los_tilemap(_x1, _y1, _x2, _y2) {
    var _lay_id = layer_get_id("Tiles_Collision");
    
    // Bảo hiểm 1: Kiểm tra xem Layer có tồn tại không
    if (_lay_id == -1) return false; 
    
    var _map_id = layer_tilemap_get_id(_lay_id);
    
    // Bảo hiểm 2: Kiểm tra xem Tilemap có tồn tại không
    if (_map_id == -1) return false;

    var _dist = point_distance(_x1, _y1, _x2, _y2);
    var _dir = point_direction(_x1, _y1, _x2, _y2);

    for (var i = 0; i < _dist; i += 8) {
        var _check_x = _x1 + lengthdir_x(i, _dir);
        var _check_y = _y1 + lengthdir_y(i, _dir);

        if (tilemap_get_at_pixel(_map_id, _check_x, _check_y) > 0) {
            return true; // Bị chặn!
        }
    }
    return false; // Thông thoáng!
}

/// @description Kiêu gọi những con gần nhau
function enmey_horde_propagation(){
	if (aggro_active) {

	    aggro_timer--;

	    if (aggro_timer <= 0) {
	        aggro_active = false;
	    }

	    // Gọi đồng đội xung quanh
	    horde_timer--;

	    if (horde_timer <= 0) {

	        horde_timer = horde_delay;

	        with (obj_enemy) {

	            if (!aggro_active) {

	                var _dist = point_distance(x, y, other.x, other.y);

	                if (_dist <= other.horde_radius) {

	                    aggro_active = true;
	                    aggro_timer = 120;

	                    aggro_target_x = other.aggro_target_x;
	                    aggro_target_y = other.aggro_target_y;

	                    state = ENEMY_STATE.INVESTIGATE;

	                    path_end();
	                    path_timer = 0;
	                }
	            }
	        }
	    }
	}	
}

/// @description Đẩy enemy ra khỏi nhau (anti-stack)
function enemy_separation() {

    var _push_x = 0;
    var _push_y = 0;
    var _count = 0;

    var _min_dist = 20;   // khoảng cách tối thiểu (hitbox)
    var _force = 0.6;     // lực đẩy

    with (obj_enemy) {
        if (id != other.id) {

            var _dist = point_distance(x, y, other.x, other.y);

            if (_dist > 0 && _dist < _min_dist) {

                // Hướng đẩy: từ enemy kia -> về mình
                var _dir = point_direction(x, y, other.x, other.y);

                // Scale lực theo khoảng cách (càng gần càng mạnh)
                var _strength = (_min_dist - _dist) / _min_dist;

                _push_x += lengthdir_x(_strength, _dir);
                _push_y += lengthdir_y(_strength, _dir);

                _count++;
            }
        }
    }

    if (_count > 0) {
        _push_x /= _count;
        _push_y /= _count;

        x += _push_x * _force;
        y += _push_y * _force;
    }
}

/// @description Steering
function enemy_calculate_velocity() {

    var _vx = 0;
    var _vy = 0;

    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    var _dir = point_direction(x, y, obj_player.x, obj_player.y);

    var _target_dist = attack_range - attack_buffer;

    // =========================
    // SEEK PLAYER (đuổi theo)
    // =========================
    if (_dist > _target_dist) {
        _vx += lengthdir_x(1, _dir);
        _vy += lengthdir_y(1, _dir);
    }
    else if (_dist < _target_dist - 4) {
        var _back = _dir + 180;
        _vx += lengthdir_x(0.6, _back);
        _vy += lengthdir_y(0.6, _back);
    }

    // =========================
    // SEPARATION (tránh chồng)
    // =========================
    with (obj_enemy) {
        if (id != other.id) {

            var _d = point_distance(x, y, other.x, other.y);

            if (_d > 0 && _d < 20) {
                var _dir2 = point_direction(x, y, other.x, other.y);

                var _force = (20 - _d) / 20;

                _vx += lengthdir_x(-_force * 1.5, _dir2);
                _vy += lengthdir_y(-_force * 1.5, _dir2);
            }
        }
    }

    // =========================
    // COHESION (tụ bầy nhẹ)
    // =========================
    var _near = instance_nearest(x, y, obj_enemy);

    if (_near != id) {
        var _d = point_distance(x, y, _near.x, _near.y);

        if (_d > 40 && _d < 120) {
            var _dir3 = point_direction(x, y, _near.x, _near.y);

            _vx += lengthdir_x(0.2, _dir3);
            _vy += lengthdir_y(0.2, _dir3);
        }
    }

    // =========================
    // NORMALIZE (giữ tốc độ ổn định)
    // =========================
    var _len = point_distance(0, 0, _vx, _vy);

    if (_len > 0) {
        _vx = (_vx / _len) * move_spd;
        _vy = (_vy / _len) * move_spd;
    }

    return [_vx, _vy];
}

/// @description Kiểm tra va chạm
function enemy_move_with_collision(_vx, _vy) {

    var _lay_id = layer_get_id("Tiles_Collision");
    var _map_id = layer_tilemap_get_id(_lay_id);

    var _blocked_x = false;
    var _blocked_y = false;

    var _step = 4; // chia nhỏ bước để không xuyên

    // =========================
    // MOVE X (chia nhỏ bước)
    // =========================
    var _move_x = _vx;

    while (abs(_move_x) > 0) {

        var _dx = clamp(_move_x, -_step, _step);
        var _side = (_dx > 0) ? bbox_right : bbox_left;

        if (tilemap_get_at_pixel(_map_id, _side + _dx, bbox_top) ||
            tilemap_get_at_pixel(_map_id, _side + _dx, bbox_bottom)) {

            _blocked_x = true;
            break;
        }

        x += _dx;
        _move_x -= _dx;
    }

    // =========================
    // MOVE Y (chia nhỏ bước)
    // =========================
    var _move_y = _vy;

    while (abs(_move_y) > 0) {

        var _dy = clamp(_move_y, -_step, _step);
        var _side = (_dy > 0) ? bbox_bottom : bbox_top;

        if (tilemap_get_at_pixel(_map_id, bbox_left, _side + _dy) ||
            tilemap_get_at_pixel(_map_id, bbox_right, _side + _dy)) {

            _blocked_y = true;
            break;
        }

        y += _dy;
        _move_y -= _dy;
    }

    return [_vx, _vy];
}