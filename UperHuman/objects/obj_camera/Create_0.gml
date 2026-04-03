
// Lấy ID của camera đang hoạt động trong room (thường là view 0)
cam = view_camera[0];

// Xác định mục tiêu bám theo (con tam giác của ông)
follow = obj_player;

// Tính toán một nửa chiều rộng và chiều cao của khung hình 
// (Dùng để tính toán giới hạn, không cho camera trượt ra ngoài mép Room)
view_w_half = camera_get_view_width(cam) * 0.5;
view_h_half = camera_get_view_height(cam) * 0.5;

// Biến lưu tọa độ đích đến của camera
xTo = xstart;
yTo = ystart;


// --- THÔNG SỐ SÚNG ---
shoot_cooldown = 0; // Biến đếm thời gian giữa các lần bắn