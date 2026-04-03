image_xscale = .5
image_yscale = .5

// --- CHỈ SỐ SỨC KHỎE ---
hp = hp_max;   
_hspd = 0;
_vspd = 0;

// --- TRẠNG THÁI --- 
// Giữ lại form này để sau làm vụ va chạm với "Lỗi hệ thống" văng ra (Knockback)
stun_timer = 0;
knockback_spd = 0;
knockback_dir = 0;

// --- SETUP TILESET VA CHẠM ---
// LƯU Ý: Đổi "Tiles_Collision" thành đúng tên layer mà ông dùng để vẽ vật cản/tường
var _layer_id = layer_get_id("Tiles_Collision");
collision_tilemap = layer_tilemap_get_id(_layer_id);


// --- HỆ THỐNG VŨ KHÍ ---
shoot_cooldown = 0;
current_weapon = 1; // Bắt đầu với súng lục

var _start_gun = global.weapons[current_weapon];

apply_weapon(_start_gun)
