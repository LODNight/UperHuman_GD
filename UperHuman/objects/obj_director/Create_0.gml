// ===== GIỚI HẠN =====
max_enemies = 100;

// ===== TIMER =====
spawn_rate = 120;
spawn_timer = spawn_rate;

// ===== NOISE SYSTEM =====
global.noise_level = 0;

// ===== TILEMAP =====
var _lay_id = layer_get_id("Tiles_Collision");
tilemap_id = layer_tilemap_get_id(_lay_id);

// ===== SPAWN CONFIG =====
spawn_min_dist = 350;  // không spawn gần player
spawn_max_dist = 700;  // spawn ngoài màn hình

enemy_list = [obj_zombie_1, obj_zombie_2];