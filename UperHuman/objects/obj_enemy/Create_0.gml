
// ===== BIẾN ĐỘNG (Dynamic Variables) =====
state = ENEMY_STATE.IDLE; 
hp = hp_max;
attack_timer = 0; 
hit_timer = 0;
prepare_timer = 0;

// ===== BIẾN HỆ THỐNG CHUNG =====
// Dùng cho Knockback khi trúng đạn
knockback_spd = 0;
knockback_dir = 0;


has_dealt_damage = false;

// ===== ADD GPS =====
path = path_add(); // Tạo một lộ trình trống
path_timer = 0;    // Bộ đếm thời gian cập nhật GPS

// Tọa độ mục tiêu khi nghe tiếng ồn
target_x = x; 
target_y = y;

image_xscale = 0.5
image_yscale = 0.5

// ===== ANIMATION =====
image_speed = 1;
image_index = 0;

direction = irandom(360); 
facing_dir = direction; // Tách riêng hướng nhìn thực tế và hướng di chuyển
image_angle = facing_dir;

// ===== MEMORY SYSTEM (TRÍ NHỚ) =====
lose_target_timer = 0;
last_known_x = x;
last_known_y = y;

// ===== INVESTIGATE SYSTEM =====
investigate_phase = 0; // 0: Đang tới điểm nghi ngờ, 1: Đang quét tìm

// ===== HORDE SYSTEM =====
aggro_target_x = x;
aggro_target_y = y;

aggro_active = false;
aggro_timer = 0;

horde_radius = 120;     // bán kính gọi đồng đội
horde_delay = 10;       // delay giữa các lần gọi
horde_timer = 0;

attack_buffer = 1; // khoảng đứng ngoài player

investigate_timer = 0;