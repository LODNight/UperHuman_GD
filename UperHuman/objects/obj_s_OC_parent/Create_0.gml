
// --- THÔNG SỐ ĐẺ QUÁI ---
enemy_list = [obj_zombie_1, obj_zombie_2];   

// --- BỘ ĐẾM THỜI GIAN ---
spawn_rate = 10;            
spawn_timer = spawn_rate;    
spawn_density = random_range(0.5, 1.5); // Có thể dùng cái này tác động vào spawn_rate sau

// --- DỮ LIỆU TƯỜNG ---
var _lay_id = layer_get_id("Tiles_Collision");
tilemap_id = layer_tilemap_get_id(_lay_id);