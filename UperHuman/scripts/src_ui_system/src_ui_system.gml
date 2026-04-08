// Hàm vẽ thanh trạng thái (Máu, XP, v.v.)
function draw_stat_bar(_x, _y, _width, _height, _current_val, _max_val, _color_fill) {
    var _percent = clamp(_current_val / _max_val,0,1);
    var _draw_width = _width * _percent;

    // Nền tối
    draw_set_color(c_dkgray);
    draw_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, false);

    // Thanh màu
    draw_set_color(_color_fill);
    draw_rectangle(_x - _width / 2, _y - _height / 2, (_x - _width / 2) + _draw_width, _y + _height / 2, false);

    // Viền đen
    draw_set_color(c_black);
    draw_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, true);

    draw_set_color(c_white); // Reset màu
}


/// @function draw_weapon_hotbar()
function draw_weapon_hotbar() {
    // Nếu Player chết hoặc không tồn tại thì không vẽ UI
    if (!instance_exists(obj_player)) return;

    // 1. LẤY KÍCH THƯỚC MÀN HÌNH GUI
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    // 2. THÔNG SỐ CỦA CÁC Ô (SLOTS)
    var _slot_size = 50; // Kích thước mỗi ô vuông (50x50 pixel)
    var _spacing = 10;   // Khoảng cách giữa các ô
    
    // Bỏ qua ô số 0, đếm từ ô số 1
    var _weapon_count = array_length(global.weapons) - 1; 
    
    // 3. TÍNH TOÁN VỊ TRÍ CĂN GIỮA
    // Tổng chiều dài của toàn bộ thanh Hotbar
    var _total_width = (_weapon_count * _slot_size) + ((_weapon_count - 1) * _spacing);
    
    // Tọa độ X bắt đầu vẽ (Lấy giữa màn hình trừ đi một nửa tổng chiều dài)
    var _start_x = (_gui_w / 2) - (_total_width / 2);
    // Tọa độ Y (Nằm sát dưới đáy, cách lên 20 pixel)
    var _y = _gui_h - _slot_size - 60; 

    // 4. VÒNG LẶP VẼ TỪNG Ô
    for (var i = 1; i <= _weapon_count; i++) {
        var _x = _start_x + (i - 1) * (_slot_size + _spacing);
        
        // Kiểm tra xem ô này có đang được Player cầm không
        var _is_active = (obj_player.current_weapon == i);

        // --- VẼ NỀN Ô VƯÔNG ---
        draw_set_alpha(0.6); // Hơi trong suốt
        draw_set_color(c_black);
        draw_rectangle(_x, _y, _x + _slot_size, _y + _slot_size, false);

        // --- VẼ VIỀN (NỔI BẬT NẾU ĐANG CHỌN) ---
        draw_set_alpha(1);
        if (_is_active) {
            draw_set_color(c_yellow); // Viền vàng nếu đang cầm
            // Mẹo: Vẽ viền dày hơn bằng cách lặp lại rectangle
            draw_rectangle(_x - 2, _y - 2, _x + _slot_size + 2, _y + _slot_size + 2, true);
        } else {
            draw_set_color(c_white);  // Viền trắng bình thường
        }
        draw_rectangle(_x, _y, _x + _slot_size, _y + _slot_size, true);

        // --- VẼ SỐ VÀ TÊN SÚNG VÀO TRONG Ô ---
        draw_set_color(c_white);
        
        // Căn lề chữ
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(_x + 5, _y + 5, string(i)); // Số 1, 2, 3 ở góc trái

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Lấy tên súng từ JSON (cắt ngắn lấy 3 chữ cái đầu cho vừa ô)
        var _gun_name = global.weapons[i].name;
        var _short_name = string_copy(_gun_name, 1, 3); 
        draw_text(_x + (_slot_size / 2), _y + (_slot_size / 2) + 10, _short_name);
    }
    
    // Reset lại căn lề chữ để không làm lỗi các UI khác
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}