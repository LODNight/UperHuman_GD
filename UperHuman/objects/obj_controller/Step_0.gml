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