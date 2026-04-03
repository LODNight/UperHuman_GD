
// ===== BIẾN ĐỘNG (Dynamic Variables) =====
state = ENEMY_STATE.WALK; 
hp = hp_max;
attack_timer = 0; 
hit_timer = 0;

// ===== BIẾN HỆ THỐNG CHUNG =====
// Dùng cho Knockback khi trúng đạn
knockback_spd = 0;
knockback_dir = 0;


has_dealt_damage = false;

// ===== ADD GPS =====
path = path_add(); // Tạo một lộ trình trống
path_timer = 0;    // Bộ đếm thời gian cập nhật GPS

image_xscale = 0.5
image_yscale = 0.5

// ===== ANIMATION =====
image_speed = 1;
image_index = 0;

//spr_walk = [noone, noone, noone, noone]; 
//spr_hit  = [noone, noone, noone, noone];
//spr_attack  = [noone, noone, noone, noone];