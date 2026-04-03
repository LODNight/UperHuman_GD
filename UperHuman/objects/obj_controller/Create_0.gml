window_set_fullscreen(true)

window_set_cursor(cr_none);

cursor_sprite = spr_aim;


// Kiểm tra xem file có tồn tại không
if (file_exists("weapons.json")) {
    // Mở file và đọc toàn bộ nội dung thành dạng chuỗi (string)
    var _file = file_text_open_read("weapons.json");
    var _json_string = "";
    
    while (!file_text_eof(_file)) {
        _json_string += file_text_read_string(_file);
        file_text_readln(_file);
    }
    file_text_close(_file);
    
    // Dịch chuỗi JSON thành Array/Struct trong GameMaker
    global.weapons = json_parse(_json_string);
}



// 1. Khai báo kích thước 1 ô gạch (Tile) của bạn - Thường là 16 hoặc 32
var _cell_size = 16; 

// 2. Tính toán xem map rộng bao nhiêu ô
var _hcells = room_width / _cell_size;
var _vcells = room_height / _cell_size;

// 3. Tạo một cái Lưới (Grid) vô hình lưu vào biến toàn cục
global.grid = mp_grid_create(0, 0, _hcells, _vcells, _cell_size, _cell_size);

// 4. Lấy dữ liệu của layer tường
var _lay_id = layer_get_id("Tiles_Collision");
var _map_id = layer_tilemap_get_id(_lay_id);

// 5. Quét qua toàn bộ map, hễ thấy có gạch tường thì đánh dấu X (Cấm đi) vào Lưới
for (var _yy = 0; _yy < _vcells; _yy++) {
    for (var _xx = 0; _xx < _hcells; _xx++) {
        var _tile = tilemap_get(_map_id, _xx, _yy);
        if (_tile > 0) { // Nếu ô này có gạch
            mp_grid_add_cell(global.grid, _xx, _yy); // Đánh dấu cấm đi
        }
    }
}



// Mặc định là TẮT vẽ đường đi
global.debug_show_paths = false;