function apply_weapon(_gun_data) {
    gun_fire_rate = _gun_data.rate;
    gun_bullet_speed = _gun_data.spd;
    gun_damage = _gun_data.damage;
	gun_length = _gun_data.length
    
    // --- DÙNG MAPPING ĐỂ LẤY ÂM THANH ---
    var _snd_name = string_trim(_gun_data.sound_name);

    if (variable_struct_exists(global.asset_map, _snd_name)) {
        gun_sound = global.asset_map[$ _snd_name]; 
    } else {
        show_debug_message("LỖI: Không có âm thanh [" + _snd_name + "] trong Asset Map!");
        gun_sound = snd_pistol_shot_1; 
    }
    
    if (variable_struct_exists(_gun_data, "range")) {
        gun_range = _gun_data.range;
    } else {
        gun_range = 500; 
    }
    
    // ==========================================
    // KIỂM TRA SÚNG CÓ BẮN NHIỀU VIÊN KHÔNG
    if (variable_struct_exists(_gun_data, "bullet_count")) {
        gun_bullet_count = _gun_data.bullet_count;
        gun_spread_angle = _gun_data.spread_angle;
    } else {
        gun_bullet_count = 1;
        gun_spread_angle = 0; 
    }
    
    // KIỂM TRA ĐỘ LỆCH NGẪU NHIÊN
    if (variable_struct_exists(_gun_data, "spawn_offset")) {
        gun_spawn_offset = _gun_data.spawn_offset;
        gun_range_variation = _gun_data.range_variation;
    } else {
        gun_spawn_offset = 0; 
        gun_range_variation = 0; 
    }
	
	// KIỂM TRA BÁN KÍNH TIẾNG ỒN
	if (variable_struct_exists(_gun_data, "noise_radius")) {
        gun_noise_radius = _gun_data.noise_radius;
    } else {
        gun_noise_radius = 100; // Tiếng bước chân mặc định nếu không có súng
    }
}