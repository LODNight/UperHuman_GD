// --- KIỂM TRA NGƯỜI CHƠI ---
if (!instance_exists(obj_player)) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// --- TÍNH TOÁN MÀU SẮC LINH HOẠT CHO THANH MÁU ---
// 1. Tính tỷ lệ % máu hiện tại (từ 0.0 đến 1.0)
var _hp_percent =clamp(obj_player.hp / obj_player.hp_max, 0, 1);

// 2. Pha màu: 
var _hp_color = merge_color(c_red, c_green, _hp_percent);

// --- VẼ THANH MÁU ---
// Gọi hàm vẽ và truyền cái biến _hp_color vừa tính được vào
draw_stat_bar(_gui_w / 2, _gui_h - 45, 300, 15, obj_player.hp, obj_player.hp_max, _hp_color);