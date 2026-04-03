/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

switch (state){
	case ENEMY_STATE.IDLE:
		enemy_state_idle()
		break
	
	case ENEMY_STATE.WALK:
		enemy_state_walk()
		break
		
	case ENEMY_STATE.HIT:
		enemy_state_hit()
		break
		
	case ENEMY_STATE.ATTACK:
		enemy_state_attack()
		break
		
	case ENEMY_STATE.DEAD:
		enemy_state_dead()
		break
}