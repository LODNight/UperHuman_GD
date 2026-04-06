if (keyboard_check_pressed(vk_escape)) game_end();

// ==========================================
// PHẦN 1: XỬ LÝ ZOOM KÍCH THƯỚC CAMERA
// ==========================================
// Lăn chuột lên -> Zoom gần lại (Giảm hệ số)
if (mouse_wheel_up()) zoom_target -= 0.1; 
// Lăn chuột xuống -> Zoom xa ra (Tăng hệ số)
if (mouse_wheel_down()) zoom_target += 0.1; 

// Ép hệ số zoom không được vượt quá giới hạn đã cài
zoom_target = clamp(zoom_target, zoom_min, zoom_max);

// Làm mượt quá trình zoom bằng Lerp
zoom_current = lerp(zoom_current, zoom_target, zoom_spd);

// Tính toán Kích thước Width/Height mới
var _new_w = default_w * zoom_current;
var _new_h = default_h * zoom_current;

// Cập nhật kích thước mới cho Camera
camera_set_view_size(cam, _new_w, _new_h);

// TÍNH LẠI Tâm điểm Camera (Cực kỳ quan trọng để bước sau không bị lỗi khóa góc)
view_w_half = _new_w * 0.5;
view_h_half = _new_h * 0.5;


// ==========================================
// PHẦN 2: XỬ LÝ DI CHUYỂN BÁM THEO MỤC TIÊU
// ==========================================
if (instance_exists(follow)) {
    xTo = follow.x;
    yTo = follow.y;
}

// Di chuyển mượt mà
x += (xTo - x) / 10;
y += (yTo - y) / 10;

// Khóa Camera trong Room (Bây giờ nó sẽ dùng w_half và h_half mới được cập nhật ở Phần 1)
x = clamp(x, view_w_half, room_width - view_w_half);
y = clamp(y, view_h_half, room_height - view_h_half);

camera_set_view_pos(cam, x - view_w_half, y - view_h_half);