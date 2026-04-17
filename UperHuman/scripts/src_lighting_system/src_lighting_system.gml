/// @function lighting_init()
/// @description Khởi tạo biến cho hệ thống bóng tối (Gọi ở sự kiện Create)
function lighting_init() {
    darkness_surf = -1; // Biến lưu trữ tấm bạt bóng tối
	// Lấy ID của Tilemap tường để dùng cho ánh sáng
    var _lay_id = layer_get_id("Tiles_Collision");
    global.tilemap_wall_id = layer_tilemap_get_id(_lay_id);
}

/// @function lighting_draw()
/// @description Vẽ lớp sương mù và khoét lỗ đèn pin (Gọi ở sự kiện Draw)
function lighting_draw() {
    // 1. Lấy thông số Camera (Dùng round để làm tròn số chống lag pixel)
    var _cam_x = camera_get_view_x(view_camera[0]);
    var _cam_y = camera_get_view_y(view_camera[0]);
    var _cam_w = round(camera_get_view_width(view_camera[0]));
    var _cam_h = round(camera_get_view_height(view_camera[0]));

    // 2. TẠO HOẶC CẬP NHẬT SURFACE KHI ZOOM
    if (!surface_exists(darkness_surf)) {
        darkness_surf = surface_create(_cam_w, _cam_h);
    } else {
        // CHECK ZOOM: Nếu kích thước camera hiện tại khác với kích thước bạt đang có
        if (surface_get_width(darkness_surf) != _cam_w || surface_get_height(darkness_surf) != _cam_h) {
            // Hủy bạt cũ đi để chống tràn RAM
            surface_free(darkness_surf);
            // Dệt bạt mới khớp với kích thước đã zoom
            darkness_surf = surface_create(_cam_w, _cam_h);
        }
    }

    // 3. Bắt đầu vẽ lên bạt bóng tối
    surface_set_target(darkness_surf);
    
    // Phủ màu đen (0.95 là tối thui, 0.25 là mờ mờ để test)
    draw_clear_alpha(c_black, 0.75); 

    // 4. Chuyển sang chế độ Cắt Lỗ
    gpu_set_blendmode(bm_subtract);

    // Chỉ khoét lỗ khi Player còn sống
    if (instance_exists(obj_player)) {
        
        // Tọa độ tương đối của Player trên màn hình Camera
        var _px = obj_player.x - _cam_x;
        var _py = obj_player.y - _cam_y;

        // -- THÔNG SỐ ĐÈN PIN --
        // (Sau này bạn có thể đưa các số này vào JSON của từng khẩu súng!)
        var _view_dist = 400; 
        var _fov = 80;       
        var _steps = 20;      
        
        var _start_angle = obj_player.image_angle - (_fov / 2);
        var _angle_step = _fov / _steps; 

        // -- VẼ HÌNH NÓN (QUẠT GIẤY) --
        draw_set_color(c_white); 
        draw_set_alpha(1);
        
        draw_primitive_begin(pr_trianglefan);
        
        // ĐIỂM SỐ 1: Tâm người chơi (Sáng nhất -> c_white, alpha 1)
        draw_vertex_color(_px, _py, c_white, 0.7); 
        
        // Vòng lặp vẽ các điểm ngoài rìa của đèn pin
        for (var i = 0; i <= _steps; i++) {
            var _current_angle = _start_angle + (i * _angle_step);
            
            var _actual_dist = 0; 
            var _ray_step = 8; 
            
            // Cho tia sáng chạy từ 0 đến khoảng cách tối đa
            for (var d = 0; d <= _view_dist; d += _ray_step) {
                var _check_x = obj_player.x + lengthdir_x(d, _current_angle);
                var _check_y = obj_player.y + lengthdir_y(d, _current_angle);
                
                // KIỂM TRA TILEMAP THAY VÌ OBJECT
                // Nếu giá trị trả về khác 0 nghĩa là có cục gạch ở đó
                if (tilemap_get_at_pixel(global.tilemap_wall_id, _check_x, _check_y) != 0) {
                    break; // Đụng tường -> Cắt tia sáng ngay
                }
                
                _actual_dist = d; 
            }
            
            // Vẽ điểm rìa ánh sáng
            var _vx = _px + lengthdir_x(_actual_dist, _current_angle);
            var _vy = _py + lengthdir_y(_actual_dist, _current_angle);
            
            draw_vertex_color(_vx, _vy, c_black, 0);
        }
        
        draw_primitive_end();
        
        // -- VẼ VÒNG SÁNG NHỎ DƯỚI CHÂN VỚI RÌA MỜ --
		var _ambient_radius = 32; // Chỉnh nhỏ bán kính từ 32 xuống 16 hoặc 12

		draw_set_alpha(0.2); // Hãm độ sáng của vòng tròn lại (0.1 là rất mờ, 0.5 là vừa)

		// Vẽ vòng tròn với bán kính mới
		draw_circle_color(_px, _py, _ambient_radius, c_white, c_black, false);

		draw_set_alpha(1); // QUAN TRỌNG: Trả lại alpha mặc định để không lỗi các đồ họa khác
		
    }

    // 5. Kết thúc khoét lỗ và trả lại cài đặt cũ
    gpu_set_blendmode(bm_normal);
    surface_reset_target();

    // 6. In tấm bạt ra màn hình (Chú ý depth của obj_controller phải thấp)
    draw_surface(darkness_surf, _cam_x, _cam_y);
}

/// @function lighting_cleanup()
/// @description Chống tràn RAM (Phải gọi ở sự kiện Clean Up)
function lighting_cleanup() {
    if (surface_exists(darkness_surf)) {
        surface_free(darkness_surf);
    }
}