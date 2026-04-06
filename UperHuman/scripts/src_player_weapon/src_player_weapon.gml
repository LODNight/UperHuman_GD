function apply_weapon(_gun_data) {
    gun_fire_rate = _gun_data.rate;
    gun_bullet_speed = _gun_data.spd;
    gun_damage = _gun_data.damage;
    gun_length = _gun_data.length;
	
	// --- DÙNG MAPPING ĐỂ LẤY ÂM THANH ---
	var _snd_name = string_trim(_gun_data.sound_name);

	// Kiểm tra xem tên âm thanh này có trong từ điển không
	if (variable_struct_exists(global.asset_map, _snd_name)) {
	    gun_sound = global.asset_map[$ _snd_name]; // Lấy dữ liệu từ Map
	} else {
	    show_debug_message("⚠️ LỖI: Không có âm thanh [" + _snd_name + "] trong Asset Map!");
	    gun_sound = snd_pistol_shot_1; // Mặc định nếu viết sai trong JSON
	}
	
	
	if (variable_struct_exists(_gun_data, "range")) {
		gun_range = _gun_data.range;
	} else {
	    gun_range = 500; // Tầm bắn mặc định 
	}
	
	
}