// Bấm ESC để thoát game
if (keyboard_check_pressed(vk_escape)) {
    game_end();
}

// 1. CẬP NHẬT TỌA ĐỘ ĐÍCH THEO NGƯỜI CHƠI
if (instance_exists(follow)) {
    xTo = follow.x;
    yTo = follow.y;
}

// 2. DI CHUYỂN CAMERA MƯỢT MÀ BẰNG LERP
// Chia cho 10 để tạo độ trễ vừa phải. Số càng lớn, camera kéo theo càng chậm.
x += (xTo - x) / 10;
y += (yTo - y) / 10;

// 3. KHÓA CAMERA BÊN TRONG HỆ THỐNG (ROOM)
// Ngăn không cho người chơi nhìn thấy phần viền đen vô tận bên ngoài map
x = clamp(x, view_w_half, room_width - view_w_half);
y = clamp(y, view_h_half, room_height - view_h_half);

// 4. ÁP DỤNG VỊ TRÍ CHÍNH THỨC
// Trừ đi một nửa kích thước view để nhân vật luôn nằm ở chính giữa màn hình
camera_set_view_pos(cam, x - view_w_half, y - view_h_half);

