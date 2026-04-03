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
        
        // Thay 0.5 bằng khoảng cách từ tâm đến nòng súng (Ví dụ: 25 pixel)
        var _distance_to_barrel = 25; 
        
        var _x_offset = lengthdir_x(_distance_to_barrel, image_angle); 
        var _y_offset = lengthdir_y(_distance_to_barrel, image_angle);
        
        // --- CODE ÂM THANH ---
        var _random_snd = choose(snd_pistol_shot_1, snd_pistol_shot_1);
        var _snd_id = audio_play_sound(_random_snd, 1, false);
        
        // --- TẠO ĐẠN ---
        // Vị trí tạo đạn bây giờ là Tâm nhân vật (x, y) + Độ dời ra nòng súng (_x_offset, _y_offset)
        var _bullet = instance_create_layer(x + _x_offset, y + _y_offset, "Instances_Projectiles", gun_bullet_obj);
        _bullet.direction = image_angle;
        _bullet.image_angle = image_angle;
        _bullet.speed = gun_bullet_speed; 
        shoot_cooldown = gun_fire_rate;
    }
}


/// @description: Hàm đổi vũ khí tối ưu
function player_switch_weapon() {
    // Duyệt qua các phím từ 1 đến số lượng súng đang có trong mảng
    for (var i = 1; i < array_length(global.weapons); i++) {
        
        // Nếu người chơi bấm phím số 'i' và phím đó khác súng đang cầm
        if (keyboard_check_pressed(ord(string(i))) && current_weapon != i) {
            
            // Cập nhật ID súng hiện tại
            current_weapon = i;
            
            // Lấy cục dữ liệu của súng tương ứng ra
            var _gun_data = global.weapons[i];
			
            // Cập nhật toàn bộ thông số
            gun_fire_rate = _gun_data.rate;
            gun_bullet_obj = _gun_data.obj;
            gun_bullet_speed = _gun_data.spd;
            
            break; // Đổi súng xong thì thoát vòng lặp ngay cho nhẹ máy
        }
    }
}