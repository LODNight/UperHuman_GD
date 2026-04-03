// --- THÔNG SỐ ĐẺ QUÁI ---
enemy_list = [obj_zombie_1, obj_zombie_2];   // Loại quái muốn đẻ

// --- BỘ ĐẾM THỜI GIAN ---
spawn_rate = 120;           // Tốc độ đẻ: 120 frame (khoảng 2 giây) đẻ 1 con
spawn_timer = spawn_rate;   // Khởi tạo bộ đếm

// --- DỮ LIỆU TƯỜNG (Để chống đẻ vào trong đá) ---
var _lay_id = layer_get_id("Tiles_Collision");
tilemap_id = layer_tilemap_get_id(_lay_id);