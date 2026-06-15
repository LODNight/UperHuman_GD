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
draw_stat_bar(
	_gui_w / 2, 
	_gui_h - 45,
	300, 
	15, 
	obj_player.hp, 
	obj_player.hp_max, 
	_hp_color
);

// --- HIỂN THỊ THỜI GIAN (ĐỒNG HỒ) ---
var _hh = floor(global.time_minutes / 60);
var _mm = floor(global.time_minutes mod 60);
var _hh_str = string(_hh);
if (_hh < 10) _hh_str = "0" + _hh_str;
var _mm_str = string(_mm);
if (_mm < 10) _mm_str = "0" + _mm_str;

var _time_str = _hh_str + ":" + _mm_str;
var _time_color = global.is_night ? c_ltgray : c_yellow;

draw_set_font(-1); // Đổi thành font của bạn nếu có
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_color(_gui_w / 2, 20, "TIME: " + _time_str, _time_color, _time_color, _time_color, _time_color, 1);
draw_set_halign(fa_left);