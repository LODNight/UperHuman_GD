// Hàm vẽ thanh trạng thái (Máu, XP, v.v.)
function draw_stat_bar(_x, _y, _width, _height, _current_val, _max_val, _color_fill) {
    var _percent = clamp(_current_val / _max_val,0,1);
    var _draw_width = _width * _percent;

    // Nền tối
    draw_set_color(c_dkgray);
    draw_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, false);

    // Thanh màu
    draw_set_color(_color_fill);
    draw_rectangle(_x - _width / 2, _y - _height / 2, (_x - _width / 2) + _draw_width, _y + _height / 2, false);

    // Viền đen
    draw_set_color(c_black);
    draw_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, true);

    draw_set_color(c_white); // Reset màu
}

