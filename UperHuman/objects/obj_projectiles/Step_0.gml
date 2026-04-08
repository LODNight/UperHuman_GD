// --- HỦY ĐẠN KHI CHẠM TƯỜNG (CÓ TẦM NHÌN DỰ ĐOÁN) ---

// Lấy tốc độ ngang và dọc của viên đạn. 
// (Nếu bạn dùng biến built-in 'speed' của GameMaker thì dùng hspeed và vspeed. 
// Còn nếu bạn tự tạo biến 'spd' và dùng lengthdir_x/y thì đổi lại tên biến tương ứng nhé)
var _h = hspeed; 
var _v = vspeed;

// Dự đoán vị trí của 4 góc ở FRAME TIẾP THEO
var _next_left = bbox_left + _h;
var _next_right = bbox_right + _h;
var _next_top = bbox_top + _v;
var _next_bottom = bbox_bottom + _v;

// Kiểm tra điểm chạm gạch trong tương lai
if (tilemap_get_at_pixel(collision_tilemap, _next_left, _next_top) != 0 || 
    tilemap_get_at_pixel(collision_tilemap, _next_right, _next_top) != 0 || 
    tilemap_get_at_pixel(collision_tilemap, _next_left, _next_bottom) != 0 || 
    tilemap_get_at_pixel(collision_tilemap, _next_right, _next_bottom) != 0) {
    
    // Đạn sắp đâm vào tường ở frame sau -> Hủy ngay lúc này để đạn vỡ ngay mép tường!
    instance_destroy();
}

var target = instance_place(x, y, obj_enemy);

if (target != noone) {
    target.hp -= damage;
	
	var text = instance_create_layer(target.x, target.y,"Instances_1", obj_damage_text)
	text.damage = damage
	
	// Phát âm thanh
	//audio_play_sound(snd_hit,1,false)
	if(target.hp  < 0){
		target.hp = 0;
	}
	
	// Đổi state sang HIT
	target.state = ENEMY_STATE.HIT;
	target.hit_timer = 8;
	
	// Truyền Knockback
    target.knockback_dir = direction; 
    target.knockback_spd = 0.7;
	
	
	instance_destroy()
}


// Tính quãng đường đạn đã bay được
var _distance_traveled = point_distance(xstart, ystart, x, y);

// Nếu bay quá tầm bắn -> Hủy viên đạn
if (_distance_traveled >= max_range) {
    instance_destroy();
}