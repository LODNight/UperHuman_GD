/// @function enemy_draw_hp_bar()
/// @description Vẽ thanh máu bo góc phía trên đầu kẻ địch
function enemy_draw_hp_bar() {
    if (hp < hp_max) {
	    // 1. Tùy chỉnh kích thước thanh máu
	    var _bar_width = 24; // Chiều dài thanh máu (tổng cộng 24 pixel)
	    var _bar_height = 3; // Chiều cao thanh máu (đã giảm mỏng xuống còn 3 pixel)
    
	    // 2. Tính toán vị trí (Nằm dưới chân)
	    var _xx = x - (_bar_width / 2) - 1; // Căn giữa thanh máu theo trục X
	    var _yy = bbox_bottom + 4;      // Đặt dưới mép chân (bbox_bottom) và cách ra 4 pixel cho thoáng
    
	    // 3. Tính phần trăm máu còn lại (từ 0 đến 1)
	    var _hp_percent = hp / hp_max;
    
	    // 4. VẼ THANH MÁU (Gồm 3 lớp đè lên nhau)
    
	    // Lớp viền đen (To hơn thanh máu thật 1 pixel mỗi cạnh)
	    draw_set_color(c_black);
	    draw_rectangle(_xx - 1, _yy - 1, _xx + _bar_width + 1, _yy + _bar_height + 1, false);
    
	    // Lớp nền xám/đỏ sẫm (Hiển thị phần máu đã mất)
	    draw_set_color(c_maroon); 
	    draw_rectangle(_xx, _yy, _xx + _bar_width, _yy + _bar_height, false);
    
	    // Lớp máu hiện tại (Màu đỏ tươi)
	    draw_set_color(c_red);
	    draw_rectangle(_xx, _yy, _xx + (_bar_width * _hp_percent), _yy + _bar_height, false);
    
	    // 5. Reset màu vẽ về màu trắng chuẩn để không bị lỗi màu các Object khác
	    draw_set_color(c_white);
	}
	
	
	// ===== PHẦN VẼ ĐƯỜNG ĐI ĐỂ DEBUG (CHỈ VẼ KHI BẬT F1) =====
	if (global.debug_show_paths) {
    
	    // 1. Kiểm tra xem quái có đang có đường đi (path) hợp lệ không
	    if (path_exists(path) && path_get_number(path) > 1) {
        
	        // 2. Tùy chỉnh màu sắc và độ mờ cho sợi dây Debug
	        draw_set_color(c_lime); // Màu xanh lá chuối cho nổi bật
	        draw_set_alpha(0.6);   // Hơi mờ một chút để không che mất cảnh vật
        
	        // 3. VẼ SỢI DÂY ĐƯỜNG ĐI
	        // true: Vẽ đường thẳng nối các điểm GPS lại với nhau
	        draw_path(path, x, y, true);
        
	        // 4. (Tùy chọn) Vẽ thêm các dấu chấm tại mỗi điểm quay xe (điểm nút)
	        // để nhìn rõ lộ trình zigzag
	        for (var i = 0; i < path_get_number(path); i++) {
	            var _px = path_get_point_x(path, i);
	            var _py = path_get_point_y(path, i);
	            draw_circle(_px, _py, 2, false); // Vẽ dấu chấm nhỏ
	        }
        
	        // 5. TRẢ LẠI TRẠNG THÁI VẼ CHUẨN (Cực kỳ quan trọng)
	        // Nếu không reset màu, các Object khác vẽ sau sẽ bị dính màu xanh lá
	        draw_set_color(c_white);
	        draw_set_alpha(1.0);
	    }
	}
}
