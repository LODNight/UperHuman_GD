// 1. Kiểm tra máu
if (hp <= 0) {
    state = ENEMY_STATE.DEAD;
}

// 2. Chạy logic
enemy_update_sprite_direction();

