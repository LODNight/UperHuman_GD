
// --- TỐI ƯU VA CHẠM ---
// Lấy ID của tilemap va chạm và lưu vào biến ngay từ đầu
var _layer_id = layer_get_id("Tiles_Collision");
collision_tilemap = layer_tilemap_get_id(_layer_id);