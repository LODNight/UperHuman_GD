// KHÔNG CÒN TRỪ MÁU TỰ ĐỘNG KHI CHẠM NỮA!
// (Sát thương sẽ do enemy tự gọi hàm player_take_damage() khi đánh trúng)

// Soft Collision: Đẩy nhẹ nhân vật ra để không bị đè lên quái vật
var _dir = point_direction(other.x, other.y, x, y);
x += lengthdir_x(0.5, _dir);
y += lengthdir_y(0.5, _dir);