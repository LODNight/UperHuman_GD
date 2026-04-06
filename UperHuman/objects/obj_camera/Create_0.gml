cam = view_camera[0];
follow = obj_player;

// --- 1. LƯU LẠI KÍCH THƯỚC GỐC ---
// Ghi nhớ kích thước màn hình mặc định để làm mốc tính toán zoom
default_w = camera_get_view_width(cam);
default_h = camera_get_view_height(cam);

// --- 2. HỆ THỐNG ZOOM ---
zoom_target = 1;     // Mức zoom người chơi muốn (1 = bình thường)
zoom_current = 1;    // Mức zoom thực tế của camera (Dùng để làm mượt)
zoom_spd = 0.1;      // Tốc độ zoom (Số càng nhỏ zoom càng từ từ)
zoom_min = 0.5;      // Zoom gần tối đa (0.5 = cận cảnh gấp đôi)
zoom_max = 1.5;      // Zoom xa tối đa (1.5 = nhìn được bao quát hơn)

// --- 3. BIẾN DI CHUYỂN ---
view_w_half = default_w * 0.5;
view_h_half = default_h * 0.5;
xTo = xstart;
yTo = ystart;