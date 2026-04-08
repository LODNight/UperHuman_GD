/// @description: Vẽ máu cho enemy
function enemy_draw_hp_bar() {
    // 1. BẢO HIỂM 1: Nếu máu <= 0 thì KHÔNG VẼ GÌ CẢ (Ẩn thanh máu luôn)
    if (hp <= 0) return; 

    // 2. BẢO HIỂM 2: Dùng hàm max() để ép máu không bao giờ rớt xuống dưới số 0
    var _display_hp = max(0, hp); 
    
    // Tính toán phần trăm máu dựa trên số đã được làm sạch
    var _hp_percent = _display_hp / hp_max;
    
    // (Bên dưới là code vẽ thanh máu của ông, tui ví dụ cấu trúc chuẩn)
    var _bar_width = 30;
    var _bar_height = 4;
    var _xx = x - (_bar_width / 2);
    var _yy = y + 10; // Nằm trên đầu quái
    
    // Vẽ nền đen
    draw_set_color(c_black);
    draw_rectangle(_xx, _yy, _xx + _bar_width, _yy + _bar_height, false);
    
    // Vẽ thanh máu đỏ (Dùng _hp_percent mới tính ở trên)
    draw_set_color(c_red);
    draw_rectangle(_xx, _yy, _xx + (_bar_width * _hp_percent), _yy + _bar_height, false);
    
    // Trả lại màu trắng
    draw_set_color(c_white);
}

/// @description: Line nhìn thấy Player
function enemy_draw_line(){
	// 2. VẼ TIA LASER TẦM NHÌN (Chỉ vẽ khi ở trạng thái IDLE)
	if (instance_exists(obj_player) && state == ENEMY_STATE.IDLE) {
	    // Bắn tia thử
	    var _is_blocked = check_los_tilemap(x, y, obj_player.x, obj_player.y);
    
	    // Đổi màu tia dựa trên kết quả
	    if (_is_blocked) {
	        draw_set_color(c_red);   // Màu Đỏ: Tia bị chặn bởi tường
	    } else {
	        draw_set_color(c_green); // Màu Xanh: Tia đang thông thoáng
	    }
    
	    // Vẽ đường thẳng từ quái đến Player
	    draw_line(x, y, obj_player.x, obj_player.y);
    
	    // Trả lại màu trắng mặc định cho game
	    draw_set_color(c_white); 
	}	
}