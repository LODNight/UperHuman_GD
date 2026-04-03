/// @function enemy_state_idle():
/// @description Trạng thái đứng yên -> Khi gặp player thì chuyển sang WALK
function enemy_state_idle() {
    if (instance_exists(obj_player)) {
        var dist = point_distance(x, y, obj_player.x, obj_player.y);
        
        if (dist <= aggro_range) {
            state = ENEMY_STATE.WALK;
        }
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
                path_start(path, spd, path_action_stop, false);
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
    // Gọi hàm knockback bạn đã viết để nó tự đẩy lùi
    enemy_apply_knockback();
    
    // Xử lý bộ đếm thời gian
    hit_timer--;
    if (hit_timer <= 0) {
        state = ENEMY_STATE.WALK;
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


/// @description Xử lý hành vi theo từng trạng thái
function enemy_update_sprite_direction (){
	// 1. Cập nhật Sprite
    //if (state == ENEMY_STATE.HIT) sprite_index = spr_hit;
    //else if (state == ENEMY_STATE.ATTACK) sprite_index = spr_attack;
    //else sprite_index = spr_walk;

    // 2. Xoay hình ảnh theo hướng di chuyển
    // (Lưu ý: Sprite mặc định của bạn phải được vẽ hướng mặt về bên Phải)
    if (speed > 0 || path_index != -1) {
        image_angle = direction;
    }
}