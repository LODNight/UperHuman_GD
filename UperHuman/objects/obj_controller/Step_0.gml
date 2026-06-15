// Nếu bấm phím F1 -> Đảo ngược trạng thái Bật/Tắt
if (keyboard_check_pressed(vk_f1)) {
    global.debug_show_paths = !global.debug_show_paths;

    // (Tùy chọn) Hiện thông báo nhỏ dưới góc màn hình để biết đã bật hay tắt
    if (global.debug_show_paths) {
        show_debug_message("DEBUG: Hiển thị đường đi [BẬT]");
    } else {
        show_debug_message("DEBUG: Hiển thị đường đi [TẮT]");
    }
}

// --- CẬP NHẬT THỜI GIAN TRÔI QUA ---
global.time_minutes += global.time_speed;
if (global.time_minutes >= 24 * 60) {
    global.time_minutes -= 24 * 60; // Reset qua ngày mới
}

// Tính giờ hiện tại để xét trời tối hay sáng (VD: tối từ 18:00 đến 06:00)
var _current_hour = global.time_minutes / 60;
if (_current_hour >= 18 || _current_hour <= 6) {
    global.is_night = true;
} else {
    global.is_night = false;
}