
/// @function enemy_state_idle():
function enemy_state_idle() {
    // Thỉnh thoảng quay đầu ngẫu nhiên ngó nghiêng
    if (irandom(100) > 98) {
        direction += random_range(-45, 45);
    }
    
    // Nếu mắt quét trúng Player -> Chuyển sang rượt (WALK)
    if (enemy_check_vision()) {
        state = ENEMY_STATE.WALK;
    }
}


/// @function enemy_state_investigate():
/// @description Nghe tiếng động, đi tới chỗ phát ra tiếng ồn để kiểm tra
function enemy_state_investigate() {
    if (enemy_check_vision()) {
		path_end();
        state = ENEMY_STATE.WALK;
        return; // Thoát hàm này ngay lập tức
    }

    // 2. VẼ ĐƯỜNG ĐI ĐẾN CHỖ CÓ TIẾNG ỒN (target_x, target_y)
    if (path_timer-- <= 0) {
        path_timer = 15;
        if (mp_grid_path(global.grid, path, x, y, target_x, target_y, true)) {
            path_start(path, move_spd, path_action_stop, false);
        }
    }

    // Cập nhật hướng quay mặt khi đi
    if (x != xprevious || y != yprevious) {
        direction = point_direction(xprevious, yprevious, x, y);
    }

    // 3. LOGIC HỦY BỎ: Đã đi tới tận nơi mà không thấy ai -> Trở về trạng thái ngủ
    var _dist_to_target = point_distance(x, y, target_x, target_y);
    if (_dist_to_target < 10) {
        path_end();
        state = ENEMY_STATE.IDLE;
    }
}

/// @function enemy_state_walk():
/// @description Trạng thái di chuyển theo đối tượng
function enemy_state_walk() {
   if (instance_exists(obj_player)) {
        // Khoảng cách đường thẳng (vẫn cần để tính tầm cắn)
        var straight_dist = point_distance(x, y, obj_player.x, obj_player.y);

        // 1. CẬP NHẬT GPS TÌM ĐƯỜNG TRƯỚC TIÊN
        if (path_timer-- <= 0) {
            path_timer = 15;
            // Vẽ đường trên lưới
            if (mp_grid_path(global.grid, path, x, y, obj_player.x, obj_player.y, true)) {
                path_start(path, move_spd, path_action_stop, false);
            } else {
                // Không tìm được đường (Player nấp trong góc kín)
                path_end();
            }
        }

        // 2. TÍNH QUÃNG ĐƯỜNG THỰC TẾ (Độ dài của đoạn GPS vừa vẽ)
        var actual_dist = path_get_length(path);


        // 3. LOGIC MẤT DẤU THÔNG MINH
        if (actual_dist > chase_range || (actual_dist == 0 && straight_dist > chase_range)) {
            path_end();
            state = ENEMY_STATE.IDLE;
        }
        // 4. LOGIC TẤN CÔNG
        else if (straight_dist <= attack_range && attack_timer <= 0) {
            path_end();
            state = ENEMY_STATE.ATTACK;
            image_index = 0;          
            has_dealt_damage = false; 
        }
        // 5. CẬP NHẬT HƯỚNG QUAY MẶT KHI ĐANG CHẠY
        else {
            if (x != xprevious || y != yprevious) {
                direction = point_direction(xprevious, yprevious, x, y);
            }
        }
    } else {
        path_end();
        state = ENEMY_STATE.IDLE;
    }
    
    // Giảm thời gian chờ hồi chiêu
    if (attack_timer > 0) {
        attack_timer--;
    }
}

/// @function enemy_apply_knockback():
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


/// @function enemy_state_hit():
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

/// @function enemy_state_attack():
/// @description Trạng thái tấn công
function enemy_state_attack() {
    
	if(image_index >= image_index - 1){
	    // SAU KHI ĐÁNH XONG: Ép nó quay về trạng thái đi bộ
	    state = ENEMY_STATE.WALK
	    // Đặt lại thời gian hồi chiêu (ví dụ 60 frame = 1 giây sau mới được cắn tiếp)
	    attack_timer = 60; 
	}
}

/// @function enemy_state_attack():
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


/// @function enemy_update_sprite_direction()
function enemy_update_sprite_direction() {
    // Ép hình ảnh luôn xoay theo hướng nhìn hiện tại (Bỏ cái if check speed đi)
    image_angle = direction;
}

// --- HỆ THỐNG TẦM NHÌN (Góc khuất) ---
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


/// @function check_los_tilemap(x1, y1, x2, y2)
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