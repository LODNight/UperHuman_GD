
/// @function load_weapons_data()
function load_weapons_data() {
    // 1. TẠO TỪ ĐIỂN MAPPING (Tất cả âm thanh, đạn... khai báo hết ở đây)
    global.asset_map = {
        "snd_pistol_shot_1": snd_pistol_shot_1,
        "snd_smg_shot_1": snd_smg_shot_1,
        "obj_ammo_1": obj_ammo_1
    };

    // 2. ĐỌC FILE JSON NHƯ CŨ
    if (file_exists("weapons.json")) {
        var _file = file_text_open_read("weapons.json");
        var _json_string = "";
		
        while (!file_text_eof(_file)) {
            _json_string += file_text_read_string(_file);
            file_text_readln(_file);
        }
        file_text_close(_file);
        
		
        global.weapons = json_parse(_json_string);
    } else {
        show_debug_message("LỖI: Không tìm thấy file weapons.json!");
    }
}