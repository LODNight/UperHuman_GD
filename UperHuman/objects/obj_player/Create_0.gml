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

// --- THÔNG SỐ SÚNG ---
shoot_cooldown = 0;


// --- KHAI BÁO KHO VŨ KHÍ (WEAPON DATABASE) ---
// Vị trí [0] bỏ trống để tương ứng với phím 1, 2, 3... cho dễ nhớ
global.weapons = [
    {}, // [0] Không dùng
    
    {   // [1] Súng lục (Pistol)
        rate: 35, 
        obj: obj_ammo_1, 
        spd: 12 
    },
    
    {   // [2] Súng máy (SMG)
        rate: 5, 
        obj: obj_ammo_1, 
        spd: 15 
    }
    // Sau này thêm [3] Shotgun, [4] Sniper chỉ cần viết thêm vào đây!
];

// Khởi tạo vũ khí mặc định
current_weapon = 1; 
var _start_gun = global.weapons[current_weapon];

gun_fire_rate = _start_gun.rate;
gun_bullet_obj = _start_gun.obj;
gun_bullet_speed = _start_gun.spd;