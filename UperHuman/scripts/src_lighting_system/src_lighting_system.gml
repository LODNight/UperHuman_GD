/// @function lighting_init()
/// @description Khởi tạo biến cho hệ thống bóng tối (Gọi ở sự kiện Create)
function lighting_init() {
    darkness_surf = -1; // Biến lưu trữ tấm bạt bóng tối
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
    draw_clear_alpha(c_black, 0.65); 

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
        
        // Vòng lặp vẽ các điểm ngoài rìa
        for (var i = 0; i <= _steps; i++) {
            var _current_angle = _start_angle + (i * _angle_step);
            var _vx = _px + lengthdir_x(_view_dist, _current_angle);
            var _vy = _py + lengthdir_y(_view_dist, _current_angle);
            
            // CÁC ĐIỂM RÌA: Nằm ở xa (Mờ nhất -> c_black, alpha 0)
            draw_vertex_color(_vx, _vy, c_black, 0);
			

        }
        
        draw_primitive_end();
        
        // -- VẼ VÒNG SÁNG NHỎ DƯỚI CHÂN VỚI RÌA MỜ --
        // Thay thế draw_circle bằng draw_circle_color
        // Tâm màu Trắng (c_white), Rìa màu Đen (c_black), false = đổ màu đặc
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