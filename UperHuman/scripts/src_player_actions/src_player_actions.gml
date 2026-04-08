/// Hàm di chuyển cho Player
function player_movement() {
    // 1. Xoay theo chuột
    image_angle = point_direction(x, y, mouse_x, mouse_y);

    // 2. Lấy Input
    var _xinput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _yinput = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    // 3. Tính toán vận tốc (Check Stun)
    if (stun_timer <= 0) {
        var _dir = point_direction(0, 0, _xinput, _yinput);
        if (_xinput != 0 || _yinput != 0) {
            _hspd = lengthdir_x(move_spd, _dir);
            _vspd = lengthdir_y(move_spd, _dir);
        } else {
            _hspd = 0;
            _vspd = 0;
        }
    } else {
        _hspd = lengthdir_x(knockback_spd, knockback_dir);
        _vspd = lengthdir_y(knockback_spd, knockback_dir);
        knockback_spd = lerp(knockback_spd, 0, 0.1);
        stun_timer--;
    }

    // 4. Va chạm với gạch (Tileset)
    var _bbox_side_x = (_hspd > 0) ? bbox_right : bbox_left;
    if (tilemap_get_at_pixel(collision_tilemap, _bbox_side_x + _hspd, bbox_top) != 0 || 
        tilemap_get_at_pixel(collision_tilemap, _bbox_side_x + _hspd, bbox_bottom) != 0) {
        if (_hspd > 0) x = x - (x mod 16) + 15 - (bbox_right - x);
        else x = x - (x mod 16) - (bbox_left - x);
        _hspd = 0;
    }
    x += _hspd;

    var _bbox_side_y = (_vspd > 0) ? bbox_bottom : bbox_top;
    if (tilemap_get_at_pixel(collision_tilemap, bbox_left, _bbox_side_y + _vspd) != 0 || 
        tilemap_get_at_pixel(collision_tilemap, bbox_right, _bbox_side_y + _vspd) != 0) {
        if (_vspd > 0) y = y - (y mod 16) + 15 - (bbox_bottom - y);
        else y = y - (y mod 16) - (bbox_top - y);
        _vspd = 0;
    }
    y += _vspd;
	
}


/// @description: Hàm bắn súng
function player_shoot() {
    if (shoot_cooldown > 0) shoot_cooldown--;

    if (mouse_check_button(mb_left) && shoot_cooldown <= 0) {
        
        // 1. Khoảng cách đẩy ra phía trước (Chiều dài súng)
        var _forward_dist = gun_length; 
        
        // 2. Khoảng cách dời sang ngang (Lệch sang phải nòng súng)
        //  Số dương (10) lệch phải, số âm (-10) lệch trái.
        var _side_dist = 5; 

        // Tính tọa độ đẩy tới trước
        var _x_forward = lengthdir_x(_forward_dist, image_angle);
        var _y_forward = lengthdir_y(_forward_dist, image_angle);
        
        // Tính tọa độ dời sang ngang (Trừ đi 90 độ để lấy góc bên phải)
        var _x_side = lengthdir_x(_side_dist, image_angle - 90);
        var _y_side = lengthdir_y(_side_dist, image_angle - 90);
        
        // Cộng dồn vị trí gốc của Player + Độ vươn tới + Độ lệch ngang
        var _spawn_x = x + _x_forward + _x_side;
        var _spawn_y = y + _y_forward + _y_side;
		
		if (tilemap_get_at_pixel(collision_tilemap, _spawn_x, _spawn_y) != 0) {
			return; // ❌ Không cho bắn
		}
        
		if (gun_sound != -1) {
		    audio_play_sound(gun_sound, 1, false);
		} else {
		    show_debug_message("ERROR: gun_sound not found!");
		}
        
        var _start_angle = image_angle - (gun_spread_angle / 2);
        var _angle_step = 0;
        if (gun_bullet_count > 1) {
            _angle_step = gun_spread_angle / (gun_bullet_count - 1);
        }

        for (var i = 0; i < gun_bullet_count; i++) {
            
            // Tính góc hướng bay
            var _bullet_dir = _start_angle + (i * _angle_step);
            
            // Tùy chọn: Thêm độ giật (Recoil) ngẫu nhiên
            var _recoil = random_range(-2, 2); 
            _bullet_dir += _recoil;
            
            // ==========================================
            // NÂNG CẤP MỚI: TÍNH TOÁN ĐỘ LỆCH NGẪU NHIÊN TẠI ĐÂY
            // ==========================================
            
            // 2. Tính toán Vị trí xuất phát ngẫu nhiên cho mỗi viên đạn
            // Lệch ngẫu nhiên quanh điểm xuất phát trung tâm dựa trên 'spawn_offset'
            var _final_spawn_x = _spawn_x + random_range(-gun_spawn_offset, gun_spawn_offset);
            var _final_spawn_y = _spawn_y + random_range(-gun_spawn_offset, gun_spawn_offset);
            
            // 3. Tính toán Tầm bắn ngẫu nhiên cho mỗi viên đạn
            // Lệch ngẫu nhiên quanh tầm bắn cơ bản dựa trên 'range_variation'
            var _final_range = gun_range + random_range(-gun_range_variation, gun_range_variation);
            
            // ==========================================
            // TẠO ĐẠN Ở VỊ TRÍ VÀ TẦM BẮN ĐÃ ĐƯỢC "BIẾN THIÊN"
            // ==========================================
			
            var _bullet = instance_create_layer(_final_spawn_x, _final_spawn_y, "Instances_Projectiles", obj_ammo_1);
            
            // Gán thông số
            _bullet.direction = _bullet_dir; 
            _bullet.image_angle = _bullet_dir; 
            
            // Tùy chọn: Shotgun ngoài đời mảnh đạn bay không đều nhau
            _bullet.speed = gun_bullet_speed + random_range(-2, 2); 
            
            // TRUYỀN TẦM BẮN VÀ SÁT THƯƠNG (BẮT BUỘC KHAI BÁO BIẾN damage VÀ max_range TRONG CREATE CỦA obj_ammo_1)
            _bullet.max_range = _final_range; // Sử dụng tầm bắn ngẫu nhiên
            _bullet.damage = gun_damage; 
        }
        
        shoot_cooldown = gun_fire_rate;
		
		// ==========================================
        // HỆ THỐNG ĐÁNH ĐỘNG ÂM THANH (SOUND AGGRO)
        // ==========================================
        // Dùng vòng lặp with để duyệt qua TẤT CẢ quái vật trên bản đồ
		
		var _sound_x = x;
		var _sound_y = y;

        with (obj_enemy) {
            // Chỉ đánh động nếu quái đang rảnh rỗi hoặc đang tìm kiếm lung tung
            if (state == ENEMY_STATE.IDLE || state == ENEMY_STATE.INVESTIGATE) {
                var _dist_to_sound = point_distance(x, y, _sound_x, _sound_y);
                
                if (_dist_to_sound <= other.gun_noise_radius) {
                    state = ENEMY_STATE.INVESTIGATE;
                    
                    // LƯU LẠI VỊ TRÍ TIẾNG SÚNG NỔ
                    target_x = _sound_x; 
                    target_y = _sound_y;
					
					path_end();
					path_timer = 0;
                }
            }
        }
		
		
		
    }
}

/// @description: Hàm đổi vũ khí 
function player_switch_weapon() {
    for (var i = 1; i < array_length(global.weapons); i++) {
        if (keyboard_check_pressed(ord(string(i))) && current_weapon != i) {
            current_weapon = i;
            var _gun_data = global.weapons[current_weapon];
            
            // Chỉ cần gọi 1 hàm duy nhất này là tự động cập nhật A-Z!
            apply_weapon(_gun_data);
            
            break; 
        }
    }
}