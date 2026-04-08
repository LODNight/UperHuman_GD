// 1. Kiểm tra chết
if (hp <= 0 && state != ENEMY_STATE.DEAD) {
    state = ENEMY_STATE.DEAD;
    image_index = 0;
}

// 2. State machine
switch (state) {
    case ENEMY_STATE.IDLE:
        enemy_state_idle();
        break;

    case ENEMY_STATE.INVESTIGATE:
        enemy_state_investigate();
        break;

    case ENEMY_STATE.WALK:
        enemy_state_walk();
        break;

    case ENEMY_STATE.ATTACK:
        enemy_state_attack();
        break;

    case ENEMY_STATE.HIT:
        enemy_state_hit();
        break;

    case ENEMY_STATE.DEAD:
        enemy_state_dead();
        break;
}

// 3. Update hướng
enemy_update_sprite_direction();