// Nếu người chơi KHÔNG trong trạng thái choáng/tàng hình tạm thời
if (stun_timer <= 0) {
    
    // Trừ máu người chơi (Thanh máu UI sẽ tự động tụt theo)
    hp -= 10; 
    
    // Bật thời gian choáng (ví dụ: 30 frames = nửa giây bất tử tạm thời)
    stun_timer = 30; 
    
    // Tính toán góc văng ra (văng ngược lại hướng con quái)
    knockback_dir = point_direction(other.x, other.y, x, y);
    knockback_spd = 2; // Lực văng của người chơi
}